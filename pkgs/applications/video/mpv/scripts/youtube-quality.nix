{ lib
, stdenvNoCC
, fetchFromGitHub
, oscSupport ? false
}:

stdenvNoCC.mkDerivation rec {
  pname = "mpv-youtube-quality";
  version = "unstable-2020-02-11";

  src = fetchFromGitHub {
    owner = "jgreco";
    repo = "mpv-youtube-quality";
    rev = "1f8c31457459ffc28cd1c3f3c2235a53efad7148";
    sha256 = "voNP8tCwCv8QnAZOPC9gqHRV/7jgCAE63VKBd/1s5ic=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/mpv/scripts
    cp youtube-quality.lua $out/share/mpv/scripts
  '' + lib.optionalString oscSupport ''
    cp youtube-quality-osc.lua $out/share/mpv/scripts
  '' + ''
    runHook postInstall
  '';

  passthru.scriptName = "youtube-quality.lua";

  meta = with lib; {
    description = "A userscript for MPV that allows you to change youtube video quality (ytdl-format) on the fly";
    homepage = "https://github.com/jgreco/mpv-youtube-quality";
    license = licenses.unfree;
    platforms = platforms.all;
    maintainers = with maintainers; [ lunik1 ];
  };
}
