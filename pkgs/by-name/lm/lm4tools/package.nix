{
  lib,
  stdenv,
  fetchFromGitHub,
  libusb,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "lm4tools";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "utzig";
    repo = "lm4tools";
    rev = "v${version}";
    hash = "sha256-ZjuCH/XjQEgg6KHAvb95/BkAy+C2OdbtBb/i6K30+uo=";
  };

  nativeBuildInputs = [
    libusb
    pkg-config
  ];
  # buildInputs = [ libusb ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://github.com/utzig/lm4tools";
    description = "Tools to enable multi-platform development on the TI Stellaris Launchpad boards.";
    licenses = with lib.licenses; [
      gpl2
      bsdOriginal
    ];
    platforms = lib.platforms.linux;
    mainProgram = "lm4flash";
    maintainers = with lib.maintainers; [ PowerUser64 ];
  };
}
