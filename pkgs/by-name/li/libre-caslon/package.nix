{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "libre-caslon";
  version = "1.002";

  srcs = [
    (fetchFromGitHub {
      owner = "impallari";
      repo = "Libre-Caslon-Text";
      rev = "c31e21f7e8cf91f18d90f778ce20e66c68219c74";
      name = "libre-caslon-text-${version}-src";
      hash = "sha256-BRz21ixBWYaD+z84+BPa/UQHLnC2EnMDP+wxVHHan30=";
    })

    (fetchFromGitHub {
      owner = "impallari";
      repo = "Libre-Caslon-Display";
      rev = "3491f6a9cfde2bc15e736463b0bc7d93054d5da1";
      name = "libre-caslon-display-${version}-src";
      hash = "sha256-JcEr+/jm5jU4uao/SsQqUUYKbW7gEO5pMB9x5Ie3WYo=";
    })
  ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    mkdir -p $out/share/doc/${pname}-${version}
    cp -v "libre-caslon-text-${version}-src/fonts/OTF/"*.otf $out/share/fonts/opentype/
    cp -v "libre-caslon-display-${version}-src/fonts/OTF/"*.otf $out/share/fonts/opentype/
    cp -v libre-caslon-text-${version}-src/README.md libre-caslon-text-${version}-src/FONTLOG.txt $out/share/doc/${pname}-${version}
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "05aajwny99yqzn1nnq1blx6h7rl54x056y12hyawfbigkzxhscns";

  meta = {
    description = "Caslon fonts based on hand-lettered American Caslons of 1960s";
    homepage = [
      "https://github.com/impallari/Libre-Caslon-Text"
      "https://github.com/impallari/Libre-Caslon-Display/"
    ];
    license = lib.licenses.ofl;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
