{
  lib,
  fetchFromGitHub,
  stdenv,
  msbuild,
  mono,
  makeWrapper,
}:

let
  pname = "spotlight-downloader";
  version = "1.5.0";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "ORelio";
    repo = "Spotlight-Downloader";
    tag = "v${version}";
    hash = "sha256-wGblbLBfH/sjUsz+hcg7OOWFavJ0k4piU/ypBEodvpY=";
  };

  nativeBuildInputs = [
    msbuild
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild

    msbuild /p:Configuration=Release SpotlightDownloader/SpotlightDownloader.csproj

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    cp -r SpotlightDownloader/bin/Release $out/share/SpotlightDownloader
    makeWrapper ${lib.getExe mono} $out/bin/SpotlightDownloader \
      --add-flags "$out/share/SpotlightDownloader/SpotlightDownloader.exe"

    runHook postInstall
  '';

  meta = {
    description = "Retrieve Windows Spotlight images from the Microsoft Spotlight API";
    license = lib.licenses.cddl;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    homepage = "https://github.com/ORelio/Spotlight-Downloader";
    platforms = lib.platforms.unix;
    mainProgram = "SpotlightDownloader";
  };
}
