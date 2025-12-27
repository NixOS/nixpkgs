{
  lib,
  pkg-config,
  rustPlatform,
  stdenv,
  systemdLibs,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sftool";
  version = "0.1.17";
  src = fetchFromGitHub {
    owner = "OpenSiFli";
    repo = "sftool";
    tag = finalAttrs.version;
    hash = "sha256-+wEQIVnuzE1DX5Cc5fpvKF8EBq4svhGFHzxtwxZQn7k=";
  };

  cargoHash = "sha256-tJqF7JYH4Mlw7rH+W8t/Wb4HLH0QqxVxmI3ZIFRke9k=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    systemdLibs # libudev-sys
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Download tool for the SiFli family of chips";
    homepage = "https://github.com/OpenSiFli/sftool";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "sftool";
  };
})
