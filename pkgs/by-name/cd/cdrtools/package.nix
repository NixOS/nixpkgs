{
  lib,
  stdenv,
  fetchurl,
  m4,
  acl,
  libcap,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cdrtools";
  version = "3.02a09";

  src = fetchurl {
    url = "mirror://sourceforge/cdrtools/cdrtools-${finalAttrs.version}.tar.bz2";
    hash = "sha256-qihDj0WO8/MUt58gKdsnZ52uHV/+FWm23ld0JRGRXoE=";
  };

  nativeBuildInputs = [ m4 ];

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    acl
    libcap
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    [
      "-Wno-error=implicit-int"
      "-Wno-error=implicit-function-declaration"
    ]
    # https://github.com/macports/macports-ports/commit/656932616eebe60f4e8cfd96d8268801dad8224d
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
      "-DNO_SCANSTACK"
    ]
  );

  postPatch = ''
    sed "/\.mk3/d" -i libschily/Targets.man
    substituteInPlace man/Makefile --replace "man4" ""
    substituteInPlace RULES/rules.prg --replace "/bin/" ""

    ln -sv i386-darwin-clang64.rul RULES/arm64-darwin-cc.rul
    ln -sv i386-darwin-clang64.rul RULES/arm64-darwin-clang.rul
    ln -sv i386-darwin-clang64.rul RULES/arm64-darwin-clang64.rul
    ln -sv i586-linux-cc.rul RULES/riscv64-linux-cc.rul
  '';

  dontConfigure = true;

  makeFlags = [
    "GMAKE_NOWARN=true"
    "INS_BASE=/"
    "INS_RBASE=/"
    "DESTDIR=${placeholder "out"}"
  ];

  enableParallelBuilding = false; # parallel building fails on some linux machines

  hardeningDisable = lib.optional stdenv.hostPlatform.isMusl "fortify";

  meta = {
    homepage = "https://cdrtools.sourceforge.net/private/cdrecord.html";
    description = "Highly portable CD/DVD/BluRay command line recording software";
    license = with lib.licenses; [
      cddl
      gpl2Plus
      lgpl21Plus
    ];
    maintainers = with lib.maintainers; [ wegank ];
    platforms = with lib.platforms; linux ++ darwin;
    # Licensing issues: This package contains code licensed under CDDL, GPL2
    # and LGPL2. There is a debate regarding the legality of distributing this
    # package in binary form.
    hydraPlatforms = [ ];
  };
})
