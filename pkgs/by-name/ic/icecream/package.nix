{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  docbook2x,
  libarchive,
  libcap_ng,
  lzo,
  pkg-config,
  zstd,
  docbook_xml_dtd_45,
}:

stdenv.mkDerivation rec {
  pname = "icecream";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "icecc";
    repo = "icecream";
    rev = version;
    sha256 = "sha256-nBdUbWNmTxKpkgFM3qbooNQISItt5eNKtnnzpBGVbd4=";
  };
  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    docbook2x
    pkg-config
  ];
  buildInputs = [
    libarchive
    libcap_ng
    lzo
    zstd
    docbook_xml_dtd_45
  ];

  meta = with lib; {
    description = "Distributed compiler with a central scheduler to share build load";
    inherit (src.meta) homepage;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ emantor ];
    platforms = with platforms; linux ++ darwin;
  };
}
