{ stdenv, gnutar, findutils, fetchurl, ... }:
{ name
, url
, version
, sha256
, patches ? [ ]
}:
stdenv.mkDerivation {
  name = "nc-app-${name}";
  inherit version patches;

  src = fetchurl {
    url = url;
    sha256 = sha256;
  };

  nativeBuildInputs = [
    gnutar
    findutils
  ];

  unpackPhase = ''
    tar -xzpf $src
    find -type f -executable -exec chmod o-x,g-x-w,a-x-w '{}' \;
  '';

  installPhase = ''
    approot="$(dirname $(dirname $(find -path '*/appinfo/info.xml' | head -n 1)))"

    if [ -d "$approot" ];
    then
      mv "$approot/" $out
      chmod -R g-w $out
    else
      echo "Could not find appinfo/info.xml"
      exit 1;
    fi
  '';
}
