{
  callPackage,
  lib,
  stdenv,
  fetchurl,
  nixos,
  testers,
  versionCheckHook,
  hello,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hello";
  version = "2.12.2";

  src = fetchurl {
    url = "mirror://gnu/hello/hello-${finalAttrs.version}.tar.gz";
    hash = "sha256-WpqZbcKSzCTc9BHO6H6S9qrluNE72caBm0x6nc4IGKs=";
  };

  # The GNU Hello `configure` script detects how to link libiconv but fails to actually make use of that.
  # Unfortunately, this cannot be a patch to `Makefile.am` because `autoreconfHook` causes a gettext
  # infrastructure mismatch error when trying to build `hello`.
  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_LDFLAGS = "-liconv";
  };

  # lib/string.h:754:20: error: expected declaration specifiers or '...' before numeric constant
  # The embedded gnulib is currently broken on cygwin when fortify is enabled.
  # This can be removed when gnulib is updated with the fix:
  # https://gitweb.git.savannah.gnu.org/gitweb/?p=gnulib.git;a=commitdiff_plain;h=c44fe03b72687c9e913727724c29bdb49c1f86e3
  hardeningDisable = lib.optional stdenv.hostPlatform.isCygwin "fortify";

  doCheck = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  # Give hello some install checks for testing purpose.
  postInstallCheck = ''
    stat "''${!outputBin}/bin/${finalAttrs.meta.mainProgram}"
  '';

  passthru.tests = {
    version = testers.testVersion { package = hello; };
  };

  passthru.tests.run = callPackage ./test.nix { hello = finalAttrs.finalPackage; };

  meta = {
    description = "Program that produces a familiar, friendly greeting";
    longDescription = ''
      GNU Hello is a program that prints "Hello, world!" when you run it.
      It is fully customizable.
    '';
    homepage = "https://www.gnu.org/software/hello/manual/";
    changelog = "https://git.savannah.gnu.org/cgit/hello.git/plain/NEWS?h=v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ stv0g ];
    mainProgram = "hello";
    platforms = lib.platforms.all;
    identifiers.cpeParts.vendor = "gnu";
  };
})
