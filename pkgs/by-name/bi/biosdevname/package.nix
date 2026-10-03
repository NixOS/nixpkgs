{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  zlib,
  pciutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "biosdevname";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "dell";
    repo = "biosdevname";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vwXVZ47VbR504stOFZXbGcLVNvWNtKdLmenA1NNZi6c=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    zlib
    pciutils
  ];

  # Don't install /lib/udev/rules.d/*-biosdevname.rules
  patches = [ ./makefile.patch ];

  configureFlags = [ "--sbindir=\${out}/bin" ];

  meta = {
    description = "Udev helper for naming devices per BIOS names";
    homepage = "https://github.com/dell/biosdevname";
    license = lib.licenses.gpl2Only;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    maintainers = [ ];
    mainProgram = "biosdevname";
  };
})
