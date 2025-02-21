{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  opencl-headers,
}:

stdenv.mkDerivation rec {
  pname = "opencl-clhpp";
  version = "2024.10.24";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-CLHPP";
    rev = "v${version}";
    sha256 = "sha256-b5f2qFJqLdGEMGnaUY8JmWj2vjZscwLua4FhgC4YP+k=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ];

  propagatedBuildInputs = [ opencl-headers ];

  strictDeps = true;

  cmakeFlags = [
    "-DBUILD_EXAMPLES=OFF"
    "-DBUILD_TESTS=OFF"
  ];

  meta = {
    description = "OpenCL Host API C++ bindings";
    homepage = "http://github.khronos.org/OpenCL-CLHPP/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.xokdvium ];
    platforms = lib.platforms.unix;
  };
}
