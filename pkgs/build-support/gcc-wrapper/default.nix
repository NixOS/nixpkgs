# The Nix `gcc' stdenv.mkDerivation is not directly usable, since it doesn't
# know where the C library and standard header files are.  Therefore
# the compiler produced by that package cannot be installed directly
# in a user environment and used from the command line.  This
# stdenv.mkDerivation provides a wrapper that sets up the right environment
# variables so that the compiler and the linker just "work".

{ name ? "", stdenv, nativeTools, nativeLibc, nativePrefix ? ""
, gcc ? null, libc ? null, binutils ? null, shell ? ""
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
  
  inherit nativeTools nativeLibc nativePrefix gcc libc binutils;
  name = if name == "" then gcc.name else name;
  langC = if nativeTools then true else gcc.langC;
  langCC = if nativeTools then true else gcc.langCC;
  langF77 = if nativeTools then false else gcc.langF77;
  shell = if shell == "" then stdenv.shell else shell;
  
  meta = if gcc != null && (gcc ? meta) then removeAttrs gcc.meta ["priority"] else
    { description = "System C compiler wrapper";
    };

  # The dynamic linker has different names on different Linux platforms.
  dynamicLinker =
    if !nativeLibc then
      (if stdenv.system == "i686-linux" then "ld-linux.so.2" else
       if stdenv.system == "x86_64-linux" then "ld-linux-x86-64.so.2" else
       if stdenv.system == "powerpc-linux" then "ld.so.1" else
       abort "don't know the name of the dynamic linker for this platform")
    else "";
}
