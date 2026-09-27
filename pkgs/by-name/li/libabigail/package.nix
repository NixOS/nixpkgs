{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  elfutils,
  libxml2,
  xxhash,
  xz,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libabigail";
  version = "2.10";

  outputs = [
    "bin"
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://mirrors.kernel.org/sourceware/libabigail/libabigail-${finalAttrs.version}.tar.xz";
    hash = "sha256-DMEOZHE5gzDgAbn+N/HoxRCKmrYysIypY01sZLw4C3g=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    elfutils
    libxml2
    xxhash
    xz
  ];

  nativeCheckInputs = [
    python3
  ];

  configureFlags = [
    "--enable-bash-completion=yes"
    "--enable-cxx11=yes"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  preCheck = ''
    # runtestdiffpkg needs cache directory
    export XDG_CACHE_HOME="$TEMPDIR"
    patchShebangs tests/
  '';

  meta = {
    description = "ABI Generic Analysis and Instrumentation Library";
    homepage = "https://sourceware.org/libabigail/";
    license = with lib.licenses; [
      asl20
      llvm-exception
    ];
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
