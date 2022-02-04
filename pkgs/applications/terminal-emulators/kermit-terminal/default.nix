{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, gtk3
, pcre
, pkg-config
, vte
}:

stdenv.mkDerivation rec {
  pname = "kermit";
  version = "3.5";

  src = fetchFromGitHub {
    name = "${pname}-${version}-src";
    owner = "orhun";
    repo = pname;
    rev = version;
    hash = "sha256-bdy2iPUV3flZrf4otuw40Xn1t/82H7ayjr7yzHLPo74=";
  };

  patches = [
    # Manpage installation. Remove it when next release arrives
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/orhun/kermit/pull/21.patch";
      hash = "sha256-mcsKQNEPgJOWFmOxKii2en2CwpUbT6tO2/YAlRSUL2A=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    gtk3
    pcre
    vte
  ];

  meta = with lib; {
    homepage = "https://github.com/orhun/kermit";
    description = "A VTE-based, simple and froggy terminal emulator";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; unix;
  };
}
