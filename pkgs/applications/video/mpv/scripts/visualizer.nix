{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "visualizer";
  version = "unstable-2023-08-13";

  src = fetchFromGitHub {
    owner = "mfcc64";
    repo = "mpv-scripts";
    rev = "7dbbfb283508714b73ead2a57b6939da1d139bd3";
    sha256 = "zzB4uBc1M2Gdr/JKY2uk8MY0hmQl1XeomkfTzuM45oE=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/mpv/scripts
    cp visualizer.lua $out/share/mpv/scripts
    runHook postInstall
  '';

  passthru.scriptName = "visualizer.lua";

  meta = with lib; {
    description = "various audio visualization";
    homepage = "https://github.com/mfcc64/mpv-scripts";
    platforms = platforms.all;
    maintainers = with maintainers; [kmein];
  };
}
