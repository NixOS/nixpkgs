{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, installShellFiles
, darwin
, testers
, pixi
}:

rustPlatform.buildRustPackage rec {
  pname = "pixi";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "prefix-dev";
    repo = "pixi";
    rev = "v${version}";
    hash = "sha256-NOa8OvZs+BoJQ9qIU1lpMmEOecZpmwwCNYpDk1LUSTI=";
  };

  cargoHash = "sha256-rDtr9ITYH5o/QPG1Iozh05iTA8c0i+3DnabXLzyqdrg=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.isDarwin (
    with darwin.apple_sdk_11_0.frameworks; [ CoreFoundation IOKit SystemConfiguration Security ]
  );


  checkFlags = [
    # Skip tests requiring network
    "--skip=add_channel"
    "--skip=add_functionality"
    "--skip=add_functionality_os"
    "--skip=add_functionality_union"
    "--skip=add_pypi_functionality"
    "--skip=test_alias"
    "--skip=test_cwd"
    "--skip=test_incremental_lock_file"
  ];

  postInstall = ''
    installShellCompletion --cmd pix \
      --bash <($out/bin/pixi completion --shell bash) \
      --fish <($out/bin/pixi completion --shell fish) \
      --zsh <($out/bin/pixi completion --shell zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = pixi;
  };

  meta = with lib; {
    description = "Package management made easy";
    homepage = "https://pixi.sh/";
    license = licenses.bsd3;
    maintainers = with lib.maintainers; [ aaronjheng edmundmiller ];
    mainProgram = "pixi";
  };
}
