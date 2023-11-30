{ lib, stdenv
, fetchCrate
, rustPlatform
, installShellFiles
, pkg-config
, libsodium
, openssl
, xxHash
, darwin
, gitImportSupport ? true
, libgit2 ? null
}:

rustPlatform.buildRustPackage rec {
  pname = "pijul";
  version = "1.0.0-beta.7";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-BXDz9po8i937/xYoIW4S/FddtcWxSmtRUWYIphgh060=";
  };

  cargoHash = "sha256-+KF1G4bDfcjHHzZR93lIR8muO6s3j5jDobr3A7Arr+Q=";

  doCheck = false;
  nativeBuildInputs = [ installShellFiles pkg-config ];
  buildInputs = [ openssl libsodium xxHash ]
    ++ (lib.optionals gitImportSupport [ libgit2 ])
    ++ (lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      CoreServices Security SystemConfiguration
    ]));

  buildFeatures = lib.optional gitImportSupport "git";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd pijul \
      --bash <($out/bin/pijul completion bash) \
      --fish <($out/bin/pijul completion fish) \
      --zsh <($out/bin/pijul completion zsh)
  '';

  meta = with lib; {
    description = "A distributed version control system";
    homepage = "https://pijul.org";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ gal_bolle dywedir fabianhjr ];
    mainProgram = "pijul";
  };
}
