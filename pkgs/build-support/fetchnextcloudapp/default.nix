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
    inherit url sha256;
  };

  nativeBuildInputs = [
    gnutar
    findutils
  ];

  unpackPhase = ''
    tar -xzpf $src
  '';

  installPhase = ''
    approot="$(dirname $(dirname $(find -path '*/appinfo/info.xml' | head -n 1)))"

    if [ -d "$approot" ];
    then
      mv "$approot/" $out
      chmod -R a-w $out
    else
      echo "Could not find appinfo/info.xml"
      exit 1;
    fi
  '';
}
