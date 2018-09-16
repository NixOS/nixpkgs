{ stdenv, fetchurl, gzip, which, unzip, jdk }:

let
  version = "6.5.3.6";
  srcs = {
    i686-linux = fetchurl {
      url = "https://cdn.sencha.com/cmd/${version}/no-jre/SenchaCmd-${version}-linux-i386.sh.zip";
      sha256 = "0g3hk3fdgmkdsr6ck1fgsmaxa9wbj2fpk84rk382ff9ny55bbzv9";
    };
    x86_64-linux = fetchurl {
      url = "https://cdn.sencha.com/cmd/${version}/no-jre/SenchaCmd-${version}-linux-amd64.sh.zip";
      sha256 = "08j8gak1xsxdjgkv6s24jv97jc49pi5yf906ynjmxb27wqpxn9mz";
    };
  };
in

stdenv.mkDerivation rec {
  inherit version;

  name = "sencha-bare-${version}";
  src = srcs.${stdenv.hostPlatform.system};

  nativeBuildInputs = [ gzip which unzip ];
  buildInputs = [ jdk ];

  sourceRoot = ".";

  configurePhase = ''
    substituteAll ${./response.varfile} response.varfile
  '';

  installPhase = ''
    ./SenchaCmd*.sh -q -dir $out -varfile response.varfile
    # disallow sencha writing into /nix/store/repo
    echo "repo.local.dir=$TMP/repo" >> $out/sencha.cfg
    rm $out/shell-wrapper.sh $out/Uninstaller
  '';

  meta = with stdenv.lib; {
    license = licenses.unfree;
    platforms = attrNames srcs;
  };
}
