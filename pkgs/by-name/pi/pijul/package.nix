{
  lib,
  stdenv,
  fetchCrate,
  rustPlatform,
  installShellFiles,
  pkg-config,
  libsodium,
  openssl,
  xxHash,
  gitImportSupport ? true,
  libgit2 ? null,
}:

rustPlatform.buildRustPackage rec {
  pname = "pijul";
  version = "1.0.0-beta.9";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-jy0mzgLw9iWuoWe2ictMTL3cHnjJ5kzs6TAK+pdm28g=";
  };

  cargoHash = "sha256-d2IlBtR3j6SF8AAagUQftCOqTqN70rDMlHkA9byxXyk=";

  doCheck = false;
  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];
  buildInputs = [
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

  meta = with lib; {
    description = "Distributed version control system";
    homepage = "https://pijul.org";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [
      gal_bolle
      dywedir
      fabianhjr
    ];
    mainProgram = "pijul";
  };
}
