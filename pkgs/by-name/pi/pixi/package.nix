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
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "prefix-dev";
    repo = "pixi";
    rev = "v${version}";
    hash = "sha256-bh8Uu6Q2AND50Qzivc6k1Z8JWudkHC2i4YW1Hxa69SM=";
  };

  cargoHash = "sha256-yMIcPwnuN7F2ZrOtJw8T+nxeSzLsYn+iC34bYeWpi/w=";

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

  # There are some CI failures with Rattler. Tests on Aarch64 has been skipped.
  # See https://github.com/prefix-dev/pixi/pull/241.
  doCheck = !stdenv.isAarch64;

  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

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
    installShellCompletion --cmd pixi \
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
