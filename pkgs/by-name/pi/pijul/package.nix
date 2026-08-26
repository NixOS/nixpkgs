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
  gitImportSupport ? true,
  libgit2 ? null,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "pijul";
  version = "1.0.0-beta.21";

  src = fetchCrate {
    inherit (finalAttrs) version pname;
    hash = "sha256-IC47l6FzlopoiVZmKojPzIQzBS6UzdgE397no6GzrR4=";
  };

  cargoHash = "sha256-Ldb+CpKiVvNOeMhdD/hfQfAAMwdwUy/npY85VBPBq5k=";

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
