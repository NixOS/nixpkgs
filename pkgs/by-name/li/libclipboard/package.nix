{
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libxcb,
  libxau,
  libxdmcp,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libclipboard";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "jtanx";
    repo = "libclipboard";
    rev = "v${finalAttrs.version}";
    hash = "sha256-553hNG8QUlt/Aff9EKYr6w279ELr+2MX7nh1SKIklhA=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8)" "cmake_minimum_required(VERSION 3.10)"
  '';

  buildInputs = [
    libxcb
    libxau
    libxdmcp
  ];
  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];
  outputs = [
    "out"
    "dev"
  ];

  meta = {
    description = "Lightweight cross-platform clipboard library";
    homepage = "https://jtanx.github.io/libclipboard";
    changelog = "https://github.com/jtanx/libclipboard/releases/tag/${finalAttrs.src.rev}";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sigmanificient ];
  };
})
