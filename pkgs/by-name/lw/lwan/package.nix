{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  zlib,
  cmake,
  enableJemalloc ? !stdenv.hostPlatform.isMusl,
  jemalloc,
}:

stdenv.mkDerivation rec {
  pname = "lwan";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "lpereira";
    repo = "lwan";
    rev = "v${version}";
    sha256 = "sha256-kH4pZXLcVqGtiGF9IXsybWc+iG8bGASmxcaCKTAB40g=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ zlib ] ++ lib.optional enableJemalloc jemalloc;

  # Note: tcmalloc and mimalloc are also supported (and normal malloc)
  cmakeFlags = lib.optional enableJemalloc "-DUSE_ALTERNATIVE_MALLOC=jemalloc";

  meta = with lib; {
    description = "Lightweight high-performance multi-threaded web server";
    mainProgram = "lwan";
    longDescription = "A lightweight and speedy web server with a low memory
      footprint (~500KiB for 10k idle connections), with minimal system calls and
      memory allocation.  Lwan contains a hand-crafted HTTP request parser. Files are
      served using the most efficient way according to their size: no copies between
      kernel and userland for files larger than 16KiB.  Smaller files are sent using
      vectored I/O of memory-mapped buffers. Header overhead is considered before
      compressing small files.  Features include: mustache templating engine and IPv6
      support.
    ";
    homepage = "https://lwan.ws/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
