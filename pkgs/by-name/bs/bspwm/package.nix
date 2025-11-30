{
  lib,
  stdenv,
  fetchFromGitHub,
  libxcb,
  libXinerama,
  xcbutil,
  xcbutilkeysyms,
  xcbutilwm,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "bspwm";
  version = "0.9.12";

  src = fetchFromGitHub {
    owner = "baskerville";
    repo = "bspwm";
    tag = version;
    sha256 = "sha256-sEheWAZgKVDCEipQTtDLNfDSA2oho9zU9gK2d6W6WSU=";
  };

  buildInputs = [
    libxcb
    libXinerama
    xcbutil
    xcbutilkeysyms
    xcbutilwm
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  passthru.tests = {
    inherit (nixosTests) startx;
  };

  meta = with lib; {
    description = "Tiling window manager based on binary space partitioning";
    homepage = "https://github.com/baskerville/bspwm";
    maintainers = with maintainers; [
      meisternu
      ncfavier
    ];
    license = licenses.bsd2;
    platforms = platforms.linux;
  };
}
