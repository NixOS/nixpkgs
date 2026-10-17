{
  lib,
  stdenv,
  fetchCrate,
  rustPlatform,
  installShellFiles,
  pkg-config,
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
  version = "1.0.0-beta.24";

  src = fetchCrate {
    inherit (finalAttrs) version pname;
    hash = "sha256-6rw9dizgwcIjsXd07H0rpb/AGd+9HBiMn5/XWhMutlc=";
  };

  cargoHash = "sha256-pIeiMCcAa713Imsk+8FbOof03M+wyP85n/SAtKECKHc=";

  # Tests require a TTY, which the Nix sandbox does not provide.
  doCheck = false;
  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];
  buildInputs = [
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
