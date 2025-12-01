{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation rec {
  version = "1.2.1";

  pname = "meslo-lg";

  meslo-lg = fetchurl {
    url = "https://raw.githubusercontent.com/andreberg/Meslo-Font/09a431d546d211130352c28eb0466e5d7d5aeaf0/dist/v${version}/Meslo%20LG%20v${version}.zip";
    name = "${pname}-${version}";
    sha256 = "1l08mxlzaz3i5bamnfr49s2k4k23vdm64b8nz2ha33ysimkbgg6h";
  };

  meslo-lg-dz = fetchurl {
    url = "https://raw.githubusercontent.com/andreberg/Meslo-Font/09a431d546d211130352c28eb0466e5d7d5aeaf0/dist/v${version}/Meslo%20LG%20DZ%20v${version}.zip";
    name = "${pname}-${version}-dz";
    sha256 = "0lnbkrvcpgz9chnvix79j6fiz36wj6n46brb7b1746182rl1l875";
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  unpackPhase = ''
    unzip -j ${meslo-lg}
    unzip -j ${meslo-lg-dz}
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "1cppf8sk6r5wjnnas9n6iyag6pj9jvaic66lvwpqg3742s5akx6x";

  meta = {
    description = "Customized version of Apple’s Menlo-Regular font";
    homepage = "https://github.com/andreberg/Meslo-Font/";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = with lib.platforms; all;
  };
}
