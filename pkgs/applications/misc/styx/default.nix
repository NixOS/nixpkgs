{ lib, stdenv, fetchFromGitHub, caddy, asciidoctor
, file, lessc, sass, multimarkdown, linkchecker
, perlPackages, python3Packages }:

stdenv.mkDerivation rec {
  pname = "styx";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner  = "styx-static";
    repo   = "styx";
    rev    = "v${version}";
    hash = "sha256-f6iA/nHpKnm3BALoQq8SzdcSzJLCFSferEf69SpgD2Y=";
  };

  server = "${caddy}/bin/caddy";
  linkcheck = "${linkchecker}/bin/linkchecker";

  nativeBuildInputs = [ asciidoctor ];

  outputs = [ "out" "lib" "themes" ];

  propagatedBuildInputs = [
    file
    lessc
    sass
    asciidoctor
    multimarkdown
    perlPackages.ImageExifTool
    python3Packages.parsimonious
  ];

  installPhase = ''
    mkdir $out
    install -D -m 777 src/styx.sh $out/bin/styx

    mkdir -p $out/share/styx-src
    cp -r ./* $out/share/styx-src

    mkdir -p $out/share/doc/styx
    asciidoctor src/doc/index.adoc       -o $out/share/doc/styx/index.html
    asciidoctor src/doc/styx-themes.adoc -o $out/share/doc/styx/styx-themes.html
    asciidoctor src/doc/library.adoc     -o $out/share/doc/styx/library.html
    cp -r src/doc/highlight $out/share/doc/styx/
    cp -r src/doc/imgs $out/share/doc/styx/

    substituteAllInPlace $out/bin/styx
    substituteAllInPlace $out/share/doc/styx/index.html
    substituteAllInPlace $out/share/doc/styx/styx-themes.html
    substituteAllInPlace $out/share/doc/styx/library.html

    mkdir -p $out/share/styx/scaffold
    cp -r src/scaffold $out/share/styx
    cp -r src/tools $out/share/styx

    mkdir $lib
    cp -r src/lib/* $lib

    mkdir $themes
    cp -r themes/* $themes
  '';

  meta = with lib; {
    description  = "Nix based static site generator";
    maintainers  = with maintainers; [ ericsagnes ];
    homepage     = "https://styx-static.github.io/styx-site/";
    downloadPage = "https://github.com/styx-static/styx/";
    platforms    = platforms.all;
    license      = licenses.mit;
    mainProgram  = "styx";
  };
}
