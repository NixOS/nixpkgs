# The Nix `gcc' derivation is not directly usable, since it doesn't
# know where the C library and standard header files are.  Therefore
# the compiler produced by that package cannot be installed directly
# in a user environment and used from the command line.  This
# derivation provides a wrapper that sets up the right environment
# variables so that the compiler and the linker just "work".

{ name, stdenv, nativeTools, nativeGlibc, nativePrefix ? ""
, gcc ? null, glibc ? null, binutils ? null
}:

assert nativeTools -> nativePrefix != "";
assert !nativeTools -> gcc != null && binutils != null;
assert !nativeGlibc -> glibc != null;

derivation {
  system = stdenv.system;
  builder = ./builder.sh;
  setupHook = ./setup-hook.sh;
  gccWrapper = ./gcc-wrapper.sh;
  ldWrapper = ./ld-wrapper.sh;
  utils = ./utils.sh;
  inherit name stdenv nativeTools nativeGlibc nativePrefix gcc glibc binutils;
  langC = if nativeTools then true else gcc.langC;
  langCC = if nativeTools then true else gcc.langCC;
  langF77 = if nativeTools then false else gcc.langF77;
}
