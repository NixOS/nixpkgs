# The Nix `gcc' stdenv.mkDerivation is not directly usable, since it doesn't
# know where the C library and standard header files are.  Therefore
# the compiler produced by that package cannot be installed directly
# in a user environment and used from the command line.  This
# stdenv.mkDerivation provides a wrapper that sets up the right environment
# variables so that the compiler and the linker just "work".

{ name ? "", stdenv, lib, nativeTools, nativeLibc, nativePrefix ? ""
, gcc ? null, libc ? null, binutils ? null, coreutils ? null, shell ? stdenv.shell
, zlib ? null
, hostPlatform, targetPlatform
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

  crossAttrs = {
    #
    # This is not the best way to do this. I think the reference should be
    # the style in the gcc-cross-wrapper, but to keep a stable stdenv now I
    # do this sufficient if/else.
    dynamicLinker =
      (if hostPlatform.arch == "arm" then "ld-linux.so.3" else
       if hostPlatform.arch == "mips" then "ld.so.1" else
       if stdenv.lib.hasSuffix "pc-gnu" hostPlatform.config then "ld.so.1" else
       abort "don't know the name of the dynamic linker for this platform");
  };

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
      (if targetPlatform.system == "i686-linux"     then "ld-linux.so.2" else
       if targetPlatform.system == "x86_64-linux"   then "ld-linux-x86-64.so.2" else
       # ARM with a wildcard, which can be "" or "-armhf".
       if targetPlatform.isArm                      then "ld-linux*.so.3" else
       if targetPlatform.system == "aarch64-linux"  then "ld-linux-aarch64.so.1" else
       if targetPlatform.system == "powerpc-linux"  then "ld.so.1" else
       if targetPlatform.system == "mips64el-linux" then "ld.so.1" else
       if targetPlatform.system == "x86_64-darwin"  then "/usr/lib/dyld" else
       if stdenv.lib.hasSuffix "pc-gnu" targetPlatform.config then "ld.so.1" else
       builtins.trace
         "Don't know the name of the dynamic linker for platform ${targetPlatform.config}, so guessing instead."
         null)
    else "";
}
