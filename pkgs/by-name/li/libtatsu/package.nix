{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libplist
, libimobiledevice-glue
, curl
}:

stdenv.mkDerivation rec {
  pname = "libtatsu";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "libtatsu";
    rev = "091edd6182bd7d90064d0eabd0e98fd53c6b3429";
    hash = "sha256-RrMqxqEuncPmJvX7D2L1zcKc/PU5TpjWMu7EyxmomjQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libplist
    libimobiledevice-glue
    curl
  ];

  meta = with lib; {
    description = "Library handling the communication with Apple's Tatsu Signing Server (TSS)";
    homepage = "https://github.com/libimobiledevice/libtatsu";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
  };
}

