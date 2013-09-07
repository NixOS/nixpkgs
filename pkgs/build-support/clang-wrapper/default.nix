# The Nix `clang' stdenv.mkDerivation is not directly usable, since it doesn't
# know where the C library and standard header files are.  Therefore
# the compiler produced by that package cannot be installed directly
# in a user environment and used from the command line.  This
# stdenv.mkDerivation provides a wrapper that sets up the right environment
# variables so that the compiler and the linker just "work".

{ name ? "", stdenv, nativeTools, nativeLibc, nativePrefix ? ""
, clang ? null, libc ? null, binutils ? null, coreutils ? null, shell ? ""
, zlib ? null, libcxx ? null
}:

assert nativeTools -> nativePrefix != "";
assert !nativeTools -> clang != null && binutils != null && coreutils != null;
assert !nativeLibc -> libc != null;

let

  clangVersion = (builtins.parseDrvName clang.name).version;
  clangName = (builtins.parseDrvName clang.name).name;
  
in

stdenv.mkDerivation {
  name =
    (if name != "" then name else clangName + "-wrapper") +
    (if clang != null && clangVersion != "" then "-" + clangVersion else "");
  
  builder = ./builder.sh;
  setupHook = ./setup-hook.sh;
  clangWrapper = ./clang-wrapper.sh;
  ldWrapper = ./ld-wrapper.sh;
  utils = ./utils.sh;
  addFlags = ./add-flags;
  
  inherit nativeTools nativeLibc nativePrefix clang clangVersion libcxx;
  gcc = clang.gcc;
  libc = if nativeLibc then null else libc;
  binutils = if nativeTools then null else binutils;
  # The wrapper scripts use 'cat', so we may need coreutils
  coreutils = if nativeTools then null else coreutils;
  
  langC = true;
  langCC = true;
  shell = if shell == "" then stdenv.shell else
    if builtins.isAttrs shell then (shell + shell.shellPath)
    else shell;

  crossAttrs = {
    shell = shell.crossDrv + shell.crossDrv.shellPath;
    libc = libc.crossDrv;
    coreutils = coreutils.crossDrv;
    binutils = binutils.crossDrv;
    clang = clang.crossDrv;
    #
    # This is not the best way to do this. I think the reference should be
    # the style in the gcc-cross-wrapper, but to keep a stable stdenv now I
    # do this sufficient if/else.
    dynamicLinker =
      (if stdenv.cross.arch == "arm" then "ld-linux.so.3" else
       if stdenv.cross.arch == "mips" then "ld.so.1" else
       if stdenv.lib.hasSuffix "pc-gnu" stdenv.cross.config then "ld.so.1" else
       abort "don't know the name of the dynamic linker for this platform");
  };
  
  meta =
    let clang_ = if clang != null then clang else {}; in
    (if clang_ ? meta then removeAttrs clang.meta ["priority"] else {}) //
    { description =
        stdenv.lib.attrByPath ["meta" "description"] "System C compiler" clang_
        + " (wrapper script)";
    };

  # The dynamic linker has different names on different Linux platforms.
  dynamicLinker =
    if !nativeLibc then
      (if stdenv.system == "i686-linux" then "ld-linux.so.2" else
       if stdenv.system == "x86_64-linux" then "ld-linux-x86-64.so.2" else
       if stdenv.isArm then "ld-linux.so.3" else
       if stdenv.system == "powerpc-linux" then "ld.so.1" else
       if stdenv.system == "mips64el-linux" then "ld.so.1" else
       abort "don't know the name of the dynamic linker for this platform")
    else "";
}
