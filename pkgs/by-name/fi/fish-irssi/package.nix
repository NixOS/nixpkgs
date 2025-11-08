{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  glib,
  openssl,
  irssi,
}:
stdenv.mkDerivation {
  pname = "fish-irssi";
  version = "unstable-2023-08-05";

  src = fetchFromGitHub {
    owner = "falsovsky";
    repo = "FiSH-irssi";
    rev = "75f754fbcc3c68a078d23ae3e2baab71acc8ed9b";
    hash = "sha256-fFu0E9uLQXPYrbBjEneXSEKm2uipwRE4A3D54XYLczE=";
  };

  patches = [ ./irssi-include-dir.patch ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    glib
    openssl
  ];

  cmakeFlags = [ "-DIRSSI_INCLUDE_PATH:PATH=${irssi}/include" ];

  meta = with lib; {
    homepage = "https://github.com/falsovsky/FiSH-irssi";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
