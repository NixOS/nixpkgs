{
  stdenvNoCC,
  fetchurl,
  fetchFromGitHub,
  unstableGitUpdater,
  lib,
  bash,
  imagemagick,
  ffmpeg,
  coreutils,
  gifLocal ? null,
  gifSource ? "",
  gifHash ? "",
}:

let
  plymouthDir = "$out/share/plymouth/themes/gifmouth";
  gif =
    if gifLocal == null && gifSource == "" then
      "./example.gif"
    else if gifLocal != null then
      gifLocal
    else
      fetchurl {
        url = gifSource;
        hash = gifHash;
      };
in
stdenvNoCC.mkDerivation {
  pname = "plymouth-gifmouth-theme";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "RemuSalminen";
    repo = "gifmouth-plymouth-theme";
    rev = "873201665aff1cc9a1ddc88463bbcc5826fe9340";
    hash = "sha256-0khA/mjV8qMF7hb02tx8z/OQ0BVRvMRDpH/8yzVLROU=";
  };

  nativeBuildInputs = [
    imagemagick
    ffmpeg
    bash
    coreutils
  ];

  buildPhase = ''
    runHook preBuild

    ${lib.getExe bash} ./gifmouth.sh ${gif}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p ${plymouthDir}
    mkdir ${plymouthDir}/frames
    mkdir ${plymouthDir}/scripts

    cp gifmouth.plymouth ${plymouthDir}
    cp frames/* ${plymouthDir}/frames/
    cp scripts/gifmouth.script ${plymouthDir}/scripts/

    substituteInPlace ${plymouthDir}/gifmouth.plymouth --replace-fail "/usr/" "$out/"

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Plymouth theme that turns any GIF/Video into an Animated theme";
    homepage = "https://github.com/RemuSalminen/gifmouth-plymouth-theme";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ mooses ];
  };
}
