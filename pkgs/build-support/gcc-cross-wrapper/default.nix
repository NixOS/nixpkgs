# The Nix `gcc' stdenv.mkDerivation is not directly usable, since it doesn't
# know where the C library and standard header files are.  Therefore
# the compiler produced by that package cannot be installed directly
# in a user environment and used from the command line.  This
# stdenv.mkDerivation provides a wrapper that sets up the right environment
# variables so that the compiler and the linker just "work".

{ name ? "", stdenv, nativeTools, nativeLibc, nativePrefix ? ""
, gcc ? null, libc ? null, binutils ? null, shell ? "", cross ? ""
}:

assert nativeTools -> nativePrefix != "";
assert !nativeTools -> gcc != null && binutils != null;
assert !nativeLibc -> libc != null;

stdenv.mkDerivation {
  builder = ./builder.sh;
  setupHook = ./setup-hook.sh;
  gccWrapper = ./gcc-wrapper.sh;
  ldWrapper = ./ld-wrapper.sh;
  utils = ./utils.sh;
  addFlags = ./add-flags;
  inherit nativeTools nativeLibc nativePrefix gcc libc binutils cross;
  name = if name == "" then gcc.name else name;
  langC = if nativeTools then true else gcc.langC;
  langCC = if nativeTools then true else gcc.langCC;
  langF77 = if nativeTools then false else gcc.langF77;
  shell = if shell == "" then stdenv.shell else shell;
  meta = if gcc != null then gcc.meta else
    { description = "System C compiler wrapper";
    };
}
