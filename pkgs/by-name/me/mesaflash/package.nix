{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libmd,
  pciutils,
}:

stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  pname = "mesaflash";
  version = "3.4.9-unstable-2025-08-10";
  #version = "3.4.9";

  src = fetchFromGitHub {
    owner = "LinuxCNC";
    repo = "mesaflash";
    rev = "26bdc39f250db327237828f4c54ff2943f1193f9";
    hash = "sha256-Wu9FisTH5+eDGiyyJuLkwZ0iL30lGmYT0I4KKRjHieQ=";
    # The latest release doesn't work with the 7i76EU
    #rev = "release/${finalAttrs.version}";
    #hash = "sha256-Q3C1UD71BesntMisf0kttSPAQG58FmPxlAflGZNrWB0=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    libmd
    pciutils
  ];

  # the makefile uses `-o0`, which doesn't work with fortify hardening
  hardeningDisable = [ "fortify" ];

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "OWNERSHIP=" # defaults to root, which fails as the Nix builder doesn't run as root
  ];

  meta = {
    description = "Configuration and diagnostic tool for Mesa Electronics PCI(E)/ETH/EPP/USB/SPI boards";
    homepage = "https://github.com/LinuxCNC/mesaflash";
    mainProgram = "mesaflash";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ wucke13 ];
    platforms = lib.platforms.linux;
  };
})
