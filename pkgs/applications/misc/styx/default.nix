{ stdenv, fetchFromGitHub, caddy, asciidoctor
, file, lessc, sass, multimarkdown, linkchecker
, perlPackages, python27 }:

stdenv.mkDerivation rec {
  name    = "styx-${version}";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner  = "styx-static";
    repo   = "styx";
    rev    = "v${version}";
    sha256 = "1dl6zmic8bv17f3ib8by66c2fj7izlnv9dh2cfa2m0ipkxk930vk";
  };

  setSourceRoot = "cd styx-*/src; export sourceRoot=`pwd`";

  server = "${caddy.bin}/bin/caddy";
  linkcheck = "${linkchecker}/bin/linkchecker";

  nativeBuildInputs = [ asciidoctor ];

  propagatedBuildInputs = [
    file
    lessc
    sass
    asciidoctor
    multimarkdown
    perlPackages.ImageExifTool
    (python27.withPackages (ps: [ ps.parsimonious ]))
  ];

  outputs = [ "out" "lib" ];

  installPhase = ''
    mkdir $out
    install -D -m 777 styx.sh $out/bin/styx

    mkdir -p $out/share/styx
    cp -r scaffold $out/share/styx
    cp -r nix $out/share/styx

    mkdir -p $out/share/doc/styx
    asciidoctor doc/index.adoc       -o $out/share/doc/styx/index.html
    asciidoctor doc/styx-themes.adoc -o $out/share/doc/styx/styx-themes.html
    asciidoctor doc/library.adoc     -o $out/share/doc/styx/library.html
    cp -r doc/highlight $out/share/doc/styx/
    cp -r doc/imgs $out/share/doc/styx/
    cp -r tools $out/share

    substituteAllInPlace $out/bin/styx
    substituteAllInPlace $out/share/doc/styx/index.html
    substituteAllInPlace $out/share/doc/styx/styx-themes.html
    substituteAllInPlace $out/share/doc/styx/library.html

    mkdir $lib
    cp -r lib/* $lib
  '';

  meta = with stdenv.lib; {
    description = "Nix based static site generator";
    maintainers = with maintainers; [ ericsagnes ];
    homepage = https://styx-static.github.io/styx-site/;
    downloadPage = https://github.com/styx-static/styx/;
    platforms = platforms.all;
    license = licenses.mit;
  };
}
