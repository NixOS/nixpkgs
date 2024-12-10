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

stdenv.mkDerivation rec {
  pname = "fish-irssi";
  version = "unstable-2021-04-16";

  src = fetchFromGitHub {
    owner = "falsovsky";
    repo = "FiSH-irssi";
    rev = "fcc484f09ce6941ba2e499605270593ddd13b81a";
    hash = "sha256-KIPnz17a0CFfoPO2dZz90j+wG/dR4pv5d0iZMRf7Vkc=";
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
    maintainers = with maintainers; [ viric ];
    platforms = platforms.unix;
  };
}
