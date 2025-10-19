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
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "CrociDB";
    repo = "bulletty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fNMUdZ5WoDUVShiKl4pitkcOlHYTKXUVfiAHVqpdWmo=";
  };

  cargoHash = "sha256-ZdJtFPEjPDQSUEtdPv3uIH44wa6mGPzm/KRp5VTOb1Y=";

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
