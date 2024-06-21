{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
, pkg-config
, perl
, openssl
}:
rustPlatform.buildRustPackage rec {
  pname = "release-plz";
  version = "0.3.73";

  src = fetchFromGitHub {
    owner = "MarcoIeni";
    repo = "release-plz";
    rev = "release-plz-v${version}";
    hash = "sha256-QRKXg/6hiF7P3yQ6wFZ5JG2aRaGX7rQU0DB2L97LKsg=";
  };

  cargoHash = "sha256-aDm4hWosaeAI21iw2Uo315u01kjXCK+LaBwt9jlwgYw=";

  nativeBuildInputs = [ installShellFiles pkg-config perl ];
  buildInputs = [ openssl ];

  buildAndTestSubdir = "crates/release_plz";

  # Tests depend on additional infrastructure to be running locally
  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd ${meta.mainProgram} \
      --bash <($out/bin/${meta.mainProgram} generate-completions bash) \
      --fish <($out/bin/${meta.mainProgram} generate-completions fish) \
      --zsh <($out/bin/${meta.mainProgram} generate-completions zsh)
  '';

  meta = {
    description = "Publish Rust crates from CI with a Release PR";
    homepage = "https://release-plz.ieni.dev";
    license = with lib.licenses; [ asl20 mit ];
    maintainers = with lib.maintainers; [ dannixon ];
    mainProgram = "release-plz";
    broken = stdenv.isDarwin;
  };
}
