{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  stdenv,
  libxkbcommon,
  wayland,
}:

rustPlatform.buildRustPackage {
  pname = "cargo-bundle";
  # the latest stable release fails to build on darwin
  version = "unstable-2023-08-18";

  src = fetchFromGitHub {
    owner = "burtonageo";
    repo = "cargo-bundle";
    rev = "c9f7a182d233f0dc4ad84e10b1ffa0d44522ea43";
    hash = "sha256-n+c83pmCvFdNRAlcadmcZvYj+IRqUYeE8CJVWWYbWDQ=";
  };

  cargoHash = "sha256-g898Oelrk/ok52raTEDhgtQ9psc0PFHd/uNnk1QeXCs=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libxkbcommon
    wayland
  ];

  meta = with lib; {
    description = "Wrap rust executables in OS-specific app bundles";
    mainProgram = "cargo-bundle";
    homepage = "https://github.com/burtonageo/cargo-bundle";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ figsoda ];
  };
}
