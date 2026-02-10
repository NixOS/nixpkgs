{
  stdenv,
  lib,
  rustPlatform,
  installShellFiles,
  fetchFromGitHub,
  fetchpatch,
  nix-update-script,
  buildPackages,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nh-unwrapped";
  version = "4.2.0"; # Did you remove the patch below (and this comment)?

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6n5SVO8zsdVTD691lri7ZcO4zpqYFU8GIvjI6dbxkA8=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/nix-community/nh/commit/8bf323483166797a204579a43ed8810113eb128c.patch";
      hash = "sha256-hg0LgDPjiPWR+1DRzqORv6QPlrds7ys4PTDXFw6PUoI=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      mkdir completions

      for shell in bash zsh fish; do
        NH_NO_CHECKS=1 ${emulator} $out/bin/nh completions $shell > completions/nh.$shell
      done

      installShellCompletion completions/*

      cargo xtask man --out-dir gen
      installManPage gen/nh.1
    ''
  );

  cargoHash = "sha256-cxZsePgraYevuYQSi3hTU2EsiDyn1epSIcvGi183fIU=";

  passthru.updateScript = nix-update-script { };

  env.NH_REV = finalAttrs.src.tag;

  meta = {
    changelog = "https://github.com/nix-community/nh/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Yet another nix cli helper";
    homepage = "https://github.com/nix-community/nh";
    license = lib.licenses.eupl12;
    mainProgram = "nh";
    maintainers = with lib.maintainers; [
      NotAShelf
      mdaniels5757
      viperML
      midischwarz12
    ];
  };
})
