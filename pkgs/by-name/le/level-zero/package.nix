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

stdenv.mkDerivation (finalAttrs: {
  pname = "level-zero";
  version = "1.26.3";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "level-zero";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AFdACq4oooxv9XMrFjDwSXO+dIoGETqhuqgc0qENkNI=";
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
    changelog = "https://github.com/oneapi-src/level-zero/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.ziguana ];
  };
})
