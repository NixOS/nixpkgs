{ stdenv, fetchFromGitHub, caddy, asciidoctor }:

stdenv.mkDerivation rec {
  name    = "styx-${version}";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner  = "styx-static";
    repo   = "styx";
    rev    = "v${version}";
    sha256 = "0wyibdyi4ld0kfhng5ldb2rlgjrci014fahxn7nnchlg7dvcc5ni";
  };

  server = caddy.bin;

  nativeBuildInputs = [ asciidoctor ];

  setSourceRoot = "cd styx-*/src; export sourceRoot=`pwd`";

  installPhase = ''
    mkdir $out
    install -D -m 777 styx.sh $out/bin/styx

    mkdir -p $out/share/styx
    cp -r lib $out/share/styx
    cp -r scaffold $out/share/styx

    mkdir -p $out/share/doc/styx
    asciidoctor doc/manual.adoc -o $out/share/doc/styx/index.html

    substituteAllInPlace $out/bin/styx
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
