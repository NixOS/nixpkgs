# The Nix `gcc' stdenv.mkDerivation is not directly usable, since it doesn't
# know where the C library and standard header files are.  Therefore
# the compiler produced by that package cannot be installed directly
# in a user environment and used from the command line.  This
# stdenv.mkDerivation provides a wrapper that sets up the right environment
# variables so that the compiler and the linker just "work".

{ name ? "", stdenv, lib, nativeTools, nativeLibc, nativePrefix ? ""
, gcc ? null, libc ? null, binutils ? null, coreutils ? null, shell ? stdenv.shell
, zlib ? null
, hostPlatform, targetPlatform, targetPackages
}:

assert nativeTools -> nativePrefix != "";
assert !nativeTools -> gcc != null && binutils != null && coreutils != null;
assert !nativeLibc -> libc != null;

# For ghdl (the vhdl language provider to gcc) we need zlib in the wrapper
assert (gcc != null && gcc ? langVhdl && gcc.langVhdl) -> zlib != null;

let

  gccVersion = (builtins.parseDrvName gcc.name).version;
  gccName = (builtins.parseDrvName gcc.name).name;

  langGo = if nativeTools then false else gcc ? langGo && gcc.langGo;
in

stdenv.mkDerivation {
  name =
    (if name != "" then name else gccName + "-wrapper") +
    (if gcc != null && gccVersion != "" then "-" + gccVersion else "");

  builder = ./builder.sh;
  setupHook = ./setup-hook.sh;
  gccWrapper = ./gcc-wrapper.sh;
  gnatWrapper = ./gnat-wrapper.sh;
  gnatlinkWrapper = ./gnatlink-wrapper.sh;
  ldWrapper = ./ld-wrapper.sh;
  ldSolarisWrapper = ./ld-solaris-wrapper.sh;
  utils = ./utils.sh;
  addFlags = ./add-flags;

  inherit nativeTools nativeLibc nativePrefix gcc;
  gcc_lib = lib.getLib gcc;
  libc = if nativeLibc then null else libc;
  libc_dev = if nativeLibc then null else lib.getDev libc;
  libc_bin = if nativeLibc then null else lib.getBin libc;
  binutils = if nativeTools then null else lib.getBin binutils;
  # The wrapper scripts use 'cat', so we may need coreutils
  coreutils = if nativeTools then null else lib.getBin coreutils;

  langC = if nativeTools then true else gcc.langC;
  langCC = if nativeTools then true else gcc.langCC;
  langFortran = if nativeTools then false else gcc ? langFortran;
  langAda = if nativeTools then false else gcc ? langAda && gcc.langAda;
  langVhdl = if nativeTools then false else gcc ? langVhdl && gcc.langVhdl;
  zlib = if gcc != null && gcc ? langVhdl then zlib else null;
  shell = shell + shell.shellPath or "";

  preferLocalBuild = true;

  meta =
    let gcc_ = if gcc != null then gcc else {}; in
    (if gcc_ ? meta then removeAttrs gcc.meta ["priority"] else {}) //
    { description =
        stdenv.lib.attrByPath ["meta" "description"] "System C compiler" gcc_
        + " (wrapper script)";
    };

  # The dynamic linker has different names on different platforms.
  dynamicLinker =
    if !nativeLibc then
      targetPackages.stdenv.cc.bintools.dynamicLinker
    else "";
}
