{
  lib,
  stdenv,
  fetchFromGitHub,
  opencbm,
  cc65,
}:

stdenv.mkDerivation {
  pname = "nibtools";
  version = "0-unstable-2024-11-30";

  src = fetchFromGitHub {
    owner = "OpenCBM";
    repo = "nibtools";
    rev = "91344e0ee357780a90ad7fe3a0a0721a2e11f265";
    hash = "sha256-0skAavJe01b+4Z7LEfS2qIhqkwj8XhOwmflhYPEynw4=";
  };

  NIX_CFLAGS_COMPILE = "-Wno-error=format-security";

  nativeBuildInputs = [
    cc65
  ];

  buildInputs = [
    opencbm
  ];

  preBuild = "mkdir build";
  makeFlags = [
    "-f"
    "GNU/Makefile"
    "linux"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv nibread nibwrite nibscan nibconv nibrepair nibsrqtest $out/bin/
    runHook postInstall
  '';

  meta = {
    description = "Disk transfer utility for imaging and converting commodore 64 disk images";
    homepage = "https://github.com/OpenCBM/nibtools/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    platforms = lib.platforms.all;
  };
}
