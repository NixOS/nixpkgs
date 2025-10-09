{
  lib,
  pkgs,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bulletty";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "CrociDB";
    repo = "bulletty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ceXHrsxUSDx4orlHTOdynYKDID/uvp8NxVMei1EqDA8=";
  };

  cargoHash = "sha256-vhZaklpNIGSMRSjD+WINphMVsAcepUJfw9WBnaxoK4c=";

  # perl is required for bulletty package build for openssl
  nativeBuildInputs = with pkgs; [
    perl
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "bulletty is a feed reader for the terminal";
    homepage = "https://bulletty.croci.dev/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.FKouhai ];
  };
})
