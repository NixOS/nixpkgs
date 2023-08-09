{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "visualizer";
  version = "unstable-2021-07-10";

  src = fetchFromGitHub {
    owner = "mfcc64";
    repo = "mpv-scripts";
    rev = "a0cd87eeb974a4602c5d8086b4051b5ab72f42e1";
    sha256 = "1xgd1nd117lpj3ppynhgaa5sbkfm7l8n6c9a2fy8p07is2dkndrq";
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
