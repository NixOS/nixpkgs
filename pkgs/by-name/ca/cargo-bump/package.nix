{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-bump";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "rustadopt";
    repo = "cargo-bump";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PhA7uC2gJcBnUQPWgZC51p/KTSxSGld3m+dd6BhW6q8=";
  };

  cargoHash = "sha256-5UyG/zGF+D5DOYWLiJPnGjAsr7e8xz+e4YUoZYerz80=";

  nativeBuildInputs = [
    pkg-config
  ];

  meta = {
    description = "Increments the version number of the current project";
    mainProgram = "cargo-bump";
    homepage = "https://github.com/wraithan/cargo-bump";
    license = with lib.licenses; [ isc ];
    maintainers = with lib.maintainers; [ cafkafk ];
  };
})
