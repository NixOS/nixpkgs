{
  lib,
  addDriverRunpath,
  cmake,
  fetchFromGitHub,
  intel-compute-runtime,
  openvino,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "level-zero";
  version = "1.24.1";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "level-zero";
    tag = "v${version}";
    hash = "sha256-mDVq8wUkCvXHTqW4niYB1JIZIQQNpHTmhPu3Ydy6IyQ=";
  };

  nativeBuildInputs = [
    cmake
    addDriverRunpath
  ];

  postInstall = ''
    mkdir -p $out/nix-support
    cat > $out/nix-support/setup-hook <<EOF
    # Setup-hook to add Intel OpenGL driver libs to LD_LIBRARY_PATH if available
    if [ -d /run/opengl-driver/lib ]; then
      export LD_LIBRARY_PATH="/run/opengl-driver/lib:$LD_LIBRARY_PATH"
    fi
    if [ -d /run/opengl-driver-32/lib ]; then
      export LD_LIBRARY_PATH="/run/opengl-driver-32/lib:$LD_LIBRARY_PATH"
    fi
    EOF
  '';

  postFixup = ''
    addDriverRunpath $out/lib/libze_loader.so
  '';

  passthru.tests = {
    inherit intel-compute-runtime openvino;
  };

  meta = {
    description = "oneAPI Level Zero Specification Headers and Loader";
    homepage = "https://github.com/oneapi-src/level-zero";
    changelog = "https://github.com/oneapi-src/level-zero/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.ziguana ];
  };
}
