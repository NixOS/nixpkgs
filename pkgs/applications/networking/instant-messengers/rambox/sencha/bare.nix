{ stdenv, fetchurl, gzip, which, unzip, jdk }:

let
  version = "6.5.2";
  srcs = {
    i686-linux = fetchurl {
      url = "https://cdn.sencha.com/cmd/${version}/no-jre/SenchaCmd-${version}-linux-i386.sh.zip";
      sha256 = "18gcqw9434xab97skcb97iw4p4s2pgggvq7jaisblap0ja00kqjr";
    };
    x86_64-linux = fetchurl {
      url = "https://cdn.sencha.com/cmd/${version}/no-jre/SenchaCmd-${version}-linux-amd64.sh.zip";
      sha256 = "1b8jv99k37q1bi7b29f23lfzxc66v5fqdmr1rxsrqchwcrllc0z7";
    };
  };
in

stdenv.mkDerivation rec {
  inherit version;

  name = "sencha-bare-${version}";
  src = srcs.${stdenv.system};

  nativeBuildInputs = [ gzip which unzip ];
  buildInputs = [ jdk ];

  sourceRoot = ".";

  configurePhase = ''
    substituteAll ${./response.varfile} response.varfile
  '';

  installPhase = ''
    ./SenchaCmd*.sh -q -dir $out -varfile response.varfile
    rm $out/shell-wrapper.sh $out/Uninstaller
  '';

  meta = with stdenv.lib; {
    license = licenses.unfree;
    platforms = attrNames srcs;
  };
}
