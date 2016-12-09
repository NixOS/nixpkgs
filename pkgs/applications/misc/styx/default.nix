{ stdenv, fetchFromGitHub, caddy, asciidoctor
, file, lessc, sass, multimarkdown }:

stdenv.mkDerivation rec {
  name    = "styx-${version}";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner  = "styx-static";
    repo   = "styx";
    rev    = "v${version}";
    sha256 = "1s4465absxqwlwhn5rf51h0s1rw25ls581yjg0fy9kbyhy979qvs";
  };

  setSourceRoot = "cd styx-*/src; export sourceRoot=`pwd`";

  server = "${caddy.bin}/bin/caddy";

  nativeBuildInputs = [ asciidoctor ];

  propagatedBuildInputs = [
    file
    lessc
    sass
    asciidoctor
    multimarkdown
  ];

  installPhase = ''
    mkdir $out
    install -D -m 777 styx.sh $out/bin/styx

    mkdir -p $out/share/styx
    cp -r lib $out/share/styx
    cp -r scaffold $out/share/styx
    cp    builder.nix $out/share/styx

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
