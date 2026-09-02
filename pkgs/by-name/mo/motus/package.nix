{
  lib,
  fetchFromGitHub,
  libxcb,
  nix-update-script,
  rustPlatform,
  stdenv,
  versionCheckHook,
  withClipboard ? true,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "motus";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "oleiade";
    repo = "motus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7lFKlU9+/NvJi9NsVpve3IvzpS8OVHaH9cs/WRGjBV8=";
  };

  cargoHash = "sha256-0qK3omTkzVxkjFn2fIowl+sFmjF/hSHAROyge5CDdFg=";

  buildInputs = lib.optionals (withClipboard && stdenv.hostPlatform.isLinux) [ libxcb ];

  buildAndTestSubdir = "crates/motus-cli";
  buildNoDefaultFeatures = !withClipboard;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Dead simple password generator";
    homepage = "https://github.com/oleiade/motus";
    changelog = "https://github.com/oleiade/motus/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ britter ];
    mainProgram = "motus";
  };
})
