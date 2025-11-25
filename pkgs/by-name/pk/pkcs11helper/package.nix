{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  openssl,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "pkcs11-helper";
  version = "1.31.0";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "pkcs11-helper";
    rev = "${pname}-${version}";
    hash = "sha256-0U3HK/6JmdNwus9fs6g86YrTAFVjgK/o7dQb69A5zlU=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [ openssl ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/OpenSC/pkcs11-helper";
    license = with licenses; [
      bsd3
      gpl2Only
    ];
    description = "Library that simplifies the interaction with PKCS#11 providers";
    platforms = platforms.unix;
  };
}
