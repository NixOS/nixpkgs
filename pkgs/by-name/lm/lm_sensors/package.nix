{
  lib,
  stdenv,
  fetchFromGitHub,
  bash,
  bison,
  flex,
  which,
  perl,
  rrdtool,
  sensord ? false,
}:

let
  version = "3.6.0";
  tag = lib.replaceStrings [ "." ] [ "-" ] version;
in

stdenv.mkDerivation rec {
  pname = "lm-sensors";
  inherit version;

  src = fetchFromGitHub {
    owner = "lm-sensors";
    repo = "lm-sensors";
    inherit tag;
    hash = "sha256-9lfHCcODlS7sZMjQhK0yQcCBEoGyZOChx/oM0CU37sY=";
  };

  outputs = [
    "bin"
    "out"
    "dev"
    "man"
    "doc"
  ];

  # Upstream build system have knob to enable and disable building of static
  # library, shared library is built unconditionally.
  postPatch = lib.optionalString stdenv.hostPlatform.isStatic ''
    sed -i 'lib/Module.mk' -e '/LIBTARGETS :=/,+1d; /-m 755/ d'
    substituteInPlace prog/sensors/Module.mk \
      --replace-fail 'lib/$(LIBSHBASENAME)' ""
  '';

  nativeBuildInputs = [
    bison
    flex
    which
  ];

  # bash is required for correctly replacing the shebangs in all tools for cross-compilation.
  buildInputs = [
    bash
    perl
  ] ++ lib.optional sensord rrdtool;

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "BINDIR=${placeholder "bin"}/bin"
    "SBINDIR=${placeholder "bin"}/bin"
    "INCLUDEDIR=${placeholder "dev"}/include"
    "MANDIR=${placeholder "man"}/share/man"
    # This is a dependency of the library.
    "ETCDIR=${placeholder "out"}/etc"

    "CC=${stdenv.cc.targetPrefix}cc"
    "AR=${stdenv.cc.targetPrefix}ar"
  ] ++ lib.optional sensord "PROG_EXTRA=sensord";

  enableParallelBuilding = true;

  # Making regexp to patch-out installing of .so symlinks from Makefile is
  # complicated, it is easier to remove them post-install.
  postInstall =
    ''
      mkdir -p $doc/share/doc/${pname}
      cp -r configs doc/* $doc/share/doc/${pname}
    ''
    + lib.optionalString stdenv.hostPlatform.isStatic ''
      rm $out/lib/*.so*
    '';

  meta = {
    homepage = "https://hwmon.wiki.kernel.org/lm_sensors";
    changelog = "https://raw.githubusercontent.com/lm-sensors/lm-sensors/${tag}/CHANGES";
    description = "Tools for reading hardware sensors";
    license = with lib.licenses; [
      lgpl21Plus
      gpl2Plus
    ];
    maintainers = with lib.maintainers; [
      pmy
      oxalica
    ];
    platforms = lib.platforms.linux;
    mainProgram = "sensors";
  };
}
