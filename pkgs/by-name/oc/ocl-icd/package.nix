{
  lib,
  stdenv,
  fetchFromGitHub,
  ruby,
  opencl-headers,
  autoreconfHook,
  windows,
}:

stdenv.mkDerivation rec {
  pname = "ocl-icd";
  version = "2.3.4";

  src = fetchFromGitHub {
    owner = "OCL-dev";
    repo = "ocl-icd";
    rev = "v${version}";
    sha256 = "sha256-7q5+33oWMA/PQOz6awC+LOBVTKeXNluHxDNAq8bJPYU=";
  };

  nativeBuildInputs = [
    autoreconfHook
    ruby
  ];

  buildInputs = [ opencl-headers ] ++ lib.optionals stdenv.hostPlatform.isWindows [ windows.dlfcn ];

  configureFlags = [
    "--enable-custom-vendordir=/run/opengl-driver/etc/OpenCL/vendors"
  ]
  ++ lib.optionals (!lib.systems.equals stdenv.buildPlatform stdenv.hostPlatform) [
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  # fixes: can't build x86_64-w64-mingw32 shared library unless -no-undefined is specified
  makeFlags = lib.optionals stdenv.hostPlatform.isWindows [ "LDFLAGS=-no-undefined" ];

  meta = with lib; {
    description = "OpenCL ICD Loader for ${opencl-headers.name}";
    mainProgram = "cllayerinfo";
    homepage = "https://github.com/OCL-dev/ocl-icd";
    license = licenses.bsd2;
    platforms = platforms.unix ++ platforms.windows;
    maintainers = with maintainers; [ r-burns ];
  };
}
