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
  version = "0.5";

  src = fetchFromGitHub {
    owner = "lpereira";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-otiPH+e+auMCyeOTq4LJYaBNv+I91kOCww7DCepQTAQ=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/lpereira/lwan/commit/9b94ff5eecec1e925103b25a43dacc226a634878.patch";
      hash = "sha256-g1ZwmEodtF1fkbIBaLT4YvH8EG8DGafHydPSYJra+c0=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ zlib ] ++ lib.optional enableJemalloc jemalloc;

  # Note: tcmalloc and mimalloc are also supported (and normal malloc)
  cmakeFlags = lib.optional enableJemalloc "-DUSE_ALTERNATIVE_MALLOC=jemalloc";

  hardeningDisable = lib.optional stdenv.hostPlatform.isMusl "pie";

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
    maintainers = with maintainers; [ leenaars ];
  };
}
