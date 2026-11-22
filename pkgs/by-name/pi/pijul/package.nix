{
  lib,
  stdenv,
  fetchCrate,
  rustPlatform,
  installShellFiles,
  pkg-config,
  aws-lc,
  dbus,
  libsodium,
  openssl,
  xxhash,
  nix-update-script,
  gitImportSupport ? true,
  libgit2 ? null,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "pijul";
  version = "1.0.0-beta.26";

  src = fetchCrate {
    inherit (finalAttrs) version pname;
    hash = "sha256-VNmIja07dgfMgB7g8XxugEv8LrsnXNyMCJpfFoijhKY=";
  };

  cargoHash = "sha256-LIvFveN3NhQUXWu809S7GviLKwcsS2E6Wt/vFku4fVE=";

  # Tests require a TTY, which the Nix sandbox does not provide.
  doCheck = false;
  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];
  buildInputs = [
    aws-lc
    dbus
    openssl
    libsodium
    xxhash
  ]
  ++ (lib.optionals gitImportSupport [ libgit2 ]);

  buildFeatures = lib.optional gitImportSupport "git";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd pijul \
      --bash <($out/bin/pijul completion bash) \
      --fish <($out/bin/pijul completion fish) \
      --zsh <($out/bin/pijul completion zsh)
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=unstable" ];
  };

  meta = {
    description = "Distributed version control system";
    homepage = "https://pijul.org";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      gal_bolle
      dywedir
      fabianhjr
    ];
    mainProgram = "pijul";
  };
})
