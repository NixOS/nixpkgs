{
  lib,
  stdenv,
  fetchFromGitHub,
  opencbm,
  cc65,
}:

stdenv.mkDerivation {
  pname = "nibtools";
  version = "0-unstable-2024-02-22";

  src = fetchFromGitHub {
    owner = "OpenCBM";
    repo = "nibtools";
    rev = "1d69f64eec55031c346a2ce115227479f9579a8a";
    hash = "sha256-+hnkj0uevURkRboTH8WbSt82pZTdWL4ii2PKr6NO0Cg=";
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

  meta = with lib; {
    description = "disk transfer utility for imaging and converting commodore 64 disk images";
    homepage = "https://github.com/OpenCBM/nibtools/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ matthewcroughan ];
    platforms = platforms.all;
  };
}
