{
  lib,
  libffi,
  rustPlatform,
  fetchFromGitHub,
  python3,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustpython";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "RustPython";
    repo = "RustPython";
    tag = finalAttrs.version;
    hash = "sha256-rjDJXXR1ByFubZtzy70DZKur6nqVmufd3TqwxN1s9kE=";
  };

  cargoHash = "sha256-I+yeaMN5wxt+l4I8qUPq2fk+OER8/QxeHAKtvvYIV9Y=";

  # freeze the stdlib into the rustpython binary
  cargoBuildFlags = [ "--features=freeze-stdlib" ];

  buildInputs = [ libffi ];

  nativeCheckInputs = [ python3 ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Python 3 interpreter in written Rust";
    homepage = "https://rustpython.github.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      prusnak
      miniharinn
    ];
    mainProgram = "rustpython";
  };
})
