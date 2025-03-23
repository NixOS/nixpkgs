{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nixpkgs-track";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "uncenter";
    repo = "nixpkgs-track";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iJqYn+MttFBmcAI2HKALAAYayFzvdAtkmNwM+IewxRM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-jC3E8BPuzRCI+smuqeWzNDA9MOcK/PDzZZPnvBVqSXI=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [
    pkg-config
    versionCheckHook
  ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Track where Nixpkgs pull requests have reached";
    homepage = "https://github.com/uncenter/nixpkgs-track";
    license = lib.licenses.mit;
    mainProgram = "nixpkgs-track";
    maintainers = with lib.maintainers; [
      isabelroses
      uncenter
    ];
  };
})
