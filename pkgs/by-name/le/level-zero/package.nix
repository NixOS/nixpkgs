{
  lib,
  addDriverRunpath,
  cmake,
  fetchFromGitHub,
  intel-compute-runtime,
  openvino,
  stdenv,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "level-zero";
<<<<<<< HEAD
  version = "1.26.3";
=======
  version = "1.25.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "level-zero";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-AFdACq4oooxv9XMrFjDwSXO+dIoGETqhuqgc0qENkNI=";
=======
    hash = "sha256-qB88S5k+HLBSOxNo6JBSGihJnY1jUdIpJTdLwgAP6bA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cmake
    addDriverRunpath
  ];

  postFixup = ''
    addDriverRunpath $out/lib/libze_loader.so
  '';

  setupHook = ./setup-hook.sh;

  passthru = {
    tests = {
      inherit intel-compute-runtime openvino;
    };
    updateScript = nix-update-script { };
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
