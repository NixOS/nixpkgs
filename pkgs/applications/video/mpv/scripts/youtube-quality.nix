{ stdenv, fetchFromGitHub, mpv-unwrapped }:

# Usage: `pkgs.mpv.override { scripts = [ pkgs.mpvScripts.youtube-quality ]; }`
stdenv.mkDerivation rec {
  pname = "mpv-youtube-quality";
  version = "unstable-2020-02-11";

  src = fetchFromGitHub {
    owner = "jgreco";
    repo = pname;
    rev = "1f8c31457459ffc28cd1c3f3c2235a53efad7148";
    sha256 = "09z6dkypg0ajvlx02270p3zmax58c0pkqkh6kh8gy2mhs3r4z0xy";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -D youtube-quality.lua $out/share/mpv/scripts/youtube-quality.lua
    runHook postInstall
  '';

  passthru.scriptName = "youtube-quality.lua";

  meta = with stdenv.lib; {
    description = "mpv script for changing YouTube video quality (ytdl-format) on the fly";
    inherit (src.meta) homepage;
    inherit (mpv-unwrapped.meta) platforms;
    maintainers = with maintainers; [ samuelgrf ];
  };
}
