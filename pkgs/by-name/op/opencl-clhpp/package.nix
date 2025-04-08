{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  opencl-headers,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opencl-clhpp";
  version = "2024.10.24";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-CLHPP";
    tag = "v${finalAttrs.version}";
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "OpenCL Host API C++ bindings";
    homepage = "http://github.khronos.org/OpenCL-CLHPP/";
    changelog = "https://github.com/KhronosGroup/OpenCL-CLHPP/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.haylin ];
  };
})
