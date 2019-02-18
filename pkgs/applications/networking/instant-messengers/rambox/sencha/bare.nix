{ stdenv, fetchurl, gzip, which, unzip, jdk }:

let
  version = "6.6.0.13";
  srcs = {
    i686-linux = fetchurl {
      url = "https://cdn.sencha.com/cmd/${version}/no-jre/SenchaCmd-${version}-linux-i386.sh.zip";
      sha256 = "15b197108b49mf0afpihkh3p68lxm7580zz2w0xsbahglnvhwyfz";
    };
    x86_64-linux = fetchurl {
      url = "https://cdn.sencha.com/cmd/${version}/no-jre/SenchaCmd-${version}-linux-amd64.sh.zip";
      sha256 = "1cxhckmx1802p9qiw09cgb1v5f30wcvnrwkshmia8p8n0q47lpp4";
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
