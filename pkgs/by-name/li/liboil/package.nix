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
    url = "https://liboil.freedesktop.org/download/liboil-${finalAttrs.version}.tar.gz";
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

  # fixes a cast in inline asm: easier than patching
  buildFlags = lib.optional stdenv.hostPlatform.isDarwin "CFLAGS=-fheinous-gnu-extensions";

  meta = {
    description = "Library of simple functions that are optimized for various CPUs";
    mainProgram = "oil-bugreport";
    homepage = "https://liboil.freedesktop.org";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
