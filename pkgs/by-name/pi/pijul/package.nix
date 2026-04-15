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
  xxHash,
  gitImportSupport ? true,
  libgit2 ? null,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pijul";
  version = "1.0.0-beta.11";

  src = fetchCrate {
    inherit (finalAttrs) version pname;
    hash = "sha256-+rMMqo2LBYlCFQJv8WFCSEJgDUbMi8DnVDKXIWm3tIk=";
  };

  cargoHash = "sha256-IhArTiReUdj49bA+XseQpOiszK801xX5LdLj8vXD8rs=";

  patches = [ ./fix-rand-0.9-sanakirja-imports.patch ];

  doCheck = false;
  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];
  buildInputs = [
    dbus
    openssl
    libsodium
    xxHash
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
    license = with lib.licenses; [ gpl2Plus ];
    maintainers = with lib.maintainers; [
      gal_bolle
      dywedir
      fabianhjr
    ];
    mainProgram = "pijul";
  };
})
