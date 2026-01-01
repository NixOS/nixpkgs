{
  lib,
  rustPlatform,
  fetchFromGitHub,
  curl,
  pkg-config,
  libgit2,
  openssl,
  zlib,
<<<<<<< HEAD
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-local-registry";
  version = "0.2.9";
=======
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-local-registry";
  version = "0.2.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "dhovart";
    repo = "cargo-local-registry";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
    hash = "sha256-DzBD7N7GQZ9nhF22DnxRse0P8MUGReOcXHQ56KOqW6I=";
  };

  cargoHash = "sha256-9DW6DkWXoGvdHjxIwgXaQP9a5Kc90SdNDRNRq6G6pLg=";
=======
    rev = "v${version}";
    hash = "sha256-XZ/OHcu3viS6LPQMyBDhxlpnC2oSgWQp7XtnKZCfMEw=";
  };

  cargoHash = "sha256-d3gWy2OR6mWluaT9Vl7UWzjHsTmTXzyts50PWVibI0o=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    curl
    pkg-config
  ];

  buildInputs = [
    curl
    libgit2
    openssl
    zlib
  ];

  # tests require internet access
  doCheck = false;

<<<<<<< HEAD
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cargo subcommand to manage local registries";
    mainProgram = "cargo-local-registry";
    homepage = "https://github.com/dhovart/cargo-local-registry";
    changelog = "https://github.com/dhovart/cargo-local-registry/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ lib.maintainers.progrm_jarvis ];
  };
})
=======
  meta = with lib; {
    description = "Cargo subcommand to manage local registries";
    mainProgram = "cargo-local-registry";
    homepage = "https://github.com/dhovart/cargo-local-registry";
    changelog = "https://github.com/dhovart/cargo-local-registry/releases/tag/${src.rev}";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = [ ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
