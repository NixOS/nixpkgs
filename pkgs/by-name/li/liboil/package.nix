{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "liboil";
  version = "0.3.17";

  src = fetchurl {
    url = "${finalAttrs.meta.homepage}/download/liboil-${finalAttrs.version}.tar.gz";
    sha256 = "0sgwic99hxlb1av8cm0albzh8myb7r3lpcwxfm606l0bkc3h4pqh";
  };

  patches = [ ./x86_64-cpuid.patch ];

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];
  outputBin = "dev"; # oil-bugreport

  nativeBuildInputs = [ pkg-config ];

  # fix "argb_paint_i386.c:53:Incorrect register `%rax' used with `l' suffix"
  # errors
  configureFlags = lib.optional (
    stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64
  ) "--build=x86_64";

  # fixes a cast in inline asm: easier than patching
  buildFlags = lib.optional stdenv.hostPlatform.isDarwin "CFLAGS=-fheinous-gnu-extensions";

  meta = {
    description = "Library of simple functions that are optimized for various CPUs";
    mainProgram = "oil-bugreport";
    homepage = "https://liboil.freedesktop.org";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ lovek323 ];
    platforms = lib.platforms.all;
  };
})
