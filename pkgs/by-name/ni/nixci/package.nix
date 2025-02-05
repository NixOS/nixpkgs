{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  Security,
  SystemConfiguration,
  IOKit,
  installShellFiles,
  nix,
}:

rustPlatform.buildRustPackage rec {
  pname = "nixci";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "srid";
    repo = "nixci";
    tag = version;
    hash = "sha256-0VvZFclqwAcKN95eusQ3lgV0pp1NRUDcVXpVUC0P4QI=";
  };

  cargoHash = "sha256-trmWeYJNev7jYJtGp9XR/emmQiiI94NM0cPFrAuD7m0=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    nix
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      IOKit
      Security
      SystemConfiguration
    ];

  postInstall = ''
    installShellCompletion --cmd nixci \
      --bash <($out/bin/nixci completion bash) \
      --fish <($out/bin/nixci completion fish) \
      --zsh <($out/bin/nixci completion zsh)
  '';

  # The rust program expects an environment (at build time) that points to the
  # devour-flake flake.
  env.DEVOUR_FLAKE = fetchFromGitHub {
    owner = "srid";
    repo = "devour-flake";
    tag = "v4";
    hash = "sha256-Vey9n9hIlWiSAZ6CCTpkrL6jt4r2JvT2ik9wa2bjeC0=";
  };

  meta = {
    description = "Define and build CI for Nix projects anywhere";
    homepage = "https://github.com/srid/nixci";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      srid
      shivaraj-bh
      rsrohitsingh682
    ];
    mainProgram = "nixci";
  };
}
