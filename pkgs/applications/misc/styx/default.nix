{ stdenv, fetchFromGitHub, caddy, asciidoctor }:

stdenv.mkDerivation rec {
  name    = "styx-${version}";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner  = "styx-static";
    repo   = "styx";
    rev    = "v${version}";
    sha256 = "0lz6mfawschfjg4mvfsqz9dv884x2lcg787zjdlnhdi5yqmjx29r";
  };

  server = caddy.bin;

  nativeBuildInputs = [ asciidoctor ];

  setSourceRoot = "cd styx-*/src; export sourceRoot=`pwd`";

  installPhase = ''
    mkdir $out
    install -D -m 777 $sourceRoot/styx.sh $out/bin/styx

    mkdir -p $out/share/styx
    cp -r $sourceRoot/sample $out/share/styx

    mkdir -p $out/share/doc/styx
    asciidoctor $sourceRoot/doc/manual.doc -o $out/share/doc/styx/index.html

    substituteAllInPlace $out/bin/styx
    substituteAllInPlace $out/share/styx/sample/templates/feed.nix
    substituteAllInPlace $out/share/doc/styx/index.html
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
