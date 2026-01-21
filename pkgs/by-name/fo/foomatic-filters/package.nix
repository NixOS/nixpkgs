{
  lib,
  stdenv,
  fetchpatch,
  fetchurl,
  pkg-config,
  perl,
  cups,
  dbus,
  enscript,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "foomatic-filters";
  version = "4.0.17";

  src = fetchurl {
    url = "https://www.openprinting.org/download/foomatic/foomatic-filters-${finalAttrs.version}.tar.gz";
    hash = "sha256-ouLlPlAlceiO65AQxFoNVGcfFXB+4QT1ycIrWep6M+M=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    perl
    cups
    dbus
    enscript
  ];

  patches = [
    (fetchpatch {
      name = "CVE-2015-8327+CVE-2015-8560.patch";
      url = "https://salsa.debian.org/debian/foomatic-filters/raw/a3abbef2d2f8c7e62d2fe64f64afe294563fdf8f/debian/patches/0500-r7406_also_consider_the_back_tick_as_an_illegal_shell_escape_character.patch";
      sha256 = "055nwi3sjf578nk40bqsch3wx8m2h65hdih0wmxflb6l0hwkq4p4";
    })
    # Fix build with gcc15
    #   process.h:31:45: note: expected 'int (*)(void)' but argument is of type 'int (*)(FILE *, FILE *, void *)'
    ./fix-incompatible-pointer-types.patch
  ];

  preConfigure = ''
    substituteInPlace foomaticrip.c \
      --replace-fail /bin/bash ${stdenv.shell}
  '';

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: foomatic_rip-options.o:/build/foomatic-filters-4.0.17/options.c:49: multiple definition of
  #     `cupsfilter'; foomatic_rip-foomaticrip.o:/build/foomatic-filters-4.0.17/foomaticrip.c:158: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  installTargets = [ "install-cups" ];

  installFlags = [
    "CUPS_FILTERS=$(out)/lib/cups/filter"
    "CUPS_BACKENDS=$(out)/lib/cups/backend"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Foomatic printing filters";
    mainProgram = "foomatic-rip";
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
})
