{
  stdenvNoCC,
  fetchurl,
  fetchFromGitHub,
  unstableGitUpdater,
  lib,
  imagemagick,
  ffmpeg,
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
  version = "1.1.0";
  src = fetchFromGitHub {
    owner = "RemuSalminen";
    repo = "gifmouth-plymouth-theme";
    rev = "6ea689312b7601a02dcb1dbe8b3e28ce789fe1b2";
    hash = "sha256-UHgpF2H/uu1G8J/ZSzLhr/ww8JjqEJ9gcDK+XHnogao=";
  };

  nativeBuildInputs = [
    imagemagick
    ffmpeg
  ];

  buildPhase = ''
    runHook preBuild

    ./gifmouth.sh ${gif}

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

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Plymouth theme that turns any GIF/Video into an Animated theme";
    homepage = "https://github.com/RemuSalminen/gifmouth-plymouth-theme";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ mooses ];
  };
}
