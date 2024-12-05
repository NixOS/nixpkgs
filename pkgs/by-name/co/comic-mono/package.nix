{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "comic-mono-font";
  version = "2020-12-28";

  src = fetchFromGitHub {
    owner = "dtinth";
    repo = "comic-mono-font";
    rev = "9a96d04cdd2919964169192e7d9de5012ef66de4";
    hash = "sha256-q8NxrluWuH23FfRlntIS0MDdl3TkkGE7umcU2plS6eU=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts
    cp *.ttf $out/share/fonts

    mkdir -p $out/etc/fonts/conf.d
    ln -s ${./comic-mono-weight.conf} $out/etc/fonts/conf.d/30-comic-mono.conf

    runHook postInstall
  '';

  meta = with lib; {
    description = "Legible monospace font that looks like Comic Sans";
    longDescription = ''
      A legible monospace font... the very typeface you’ve been trained to
      recognize since childhood. This font is a fork of Shannon Miwa’s Comic
      Shanns (version 1).
    '';
    homepage = "https://dtinth.github.io/comic-mono-font/";

    license = licenses.mit;
    maintainers = with maintainers; [ an-empty-string totoroot ];
    platforms = platforms.all;
  };
}
