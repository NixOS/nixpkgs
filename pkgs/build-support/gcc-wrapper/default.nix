# The Nix `gcc' derivation is not directly usable, since it doesn't
# know where the C library and standard header files are.  Therefore
# the compiler produced by that package cannot be installed directly
# in a user environment and used from the command line.  This
# derivation provides a wrapper that sets up the right environment
# variables so that the compiler and the linker just "work".

{name, stdenv, isNative, gcc ? null, glibc ? null, binutils ? null}:

assert isNative -> gcc != "";
assert !isNative -> gcc != null && glibc != null && binutils != null;

derivation {
  system = stdenv.system;
  builder = ./builder.sh;
  setupHook = ./setup-hook.sh;
  gccWrapper = ./gcc-wrapper.sh;
  ldWrapper = ./ld-wrapper.sh;
  inherit name stdenv isNative gcc glibc binutils;
  langC = if isNative then true else gcc.langC;
  langCC = if isNative then true else gcc.langCC;
  langF77 = if isNative then false else gcc.langF77;
}
