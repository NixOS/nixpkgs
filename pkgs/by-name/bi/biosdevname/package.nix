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
    sha256 = "19wbb79x9h79k55sgd4dylvdbhhrvfaiaknbw9s1wvfmirkxa1dz";
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
    license = lib.licenses.gpl2Only;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    maintainers = [ ];
    mainProgram = "biosdevname";
  };
})
