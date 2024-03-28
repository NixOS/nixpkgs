{ lib, stdenvNoCC, fetchFromGitHub, yt-dlp }:

stdenvNoCC.mkDerivation {
  pname = "mpv-youtube-chat";
  version = "unstable-2023-08-31";

  src = fetchFromGitHub {
    owner = "BanchouBoo";
    repo = "mpv-youtube-chat";
    rev = "90849ac1d03da4d5facda1e03712b6cd57ca364e";
    hash = "sha256-22rTiUX6gYR7iknKLoKdBLhY8PMtXIIBLnckt52Sf2E=";
  };

  postPatch = ''
    substituteInPlace main.lua \
      --replace "opts['yt-dlp-path'] = 'yt-dlp'" \
      "opts['yt-dlp-path'] = '${lib.getExe yt-dlp}'"
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -D -t $out/share/mpv/scripts main.lua
    runHook postInstall
  '';

  passthru.scriptName = "main.lua";

  meta = with lib; {
    description = "MPV script to overlay youtube chat on top of a video using yt-dlp";
    homepage = "https://github.com/BanchouBoo/mpv-youtube-chat";
    license = licenses.mit;
    platforms = yt-dlp.meta.platforms;
    maintainers = with maintainers; [ fliegendewurst ];
  };
}
