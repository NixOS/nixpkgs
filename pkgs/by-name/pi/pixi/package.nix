{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  installShellFiles,
  darwin,
  testers,
  pixi,
}:

rustPlatform.buildRustPackage rec {
  pname = "pixi";
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "prefix-dev";
    repo = "pixi";
    rev = "v${version}";
    hash = "sha256-pXJna0WuosQ21u+ImIc70OaG63xVODLaWFkuYqxUc/Y=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-vCtTvhXGLnc1qIo9WpFGmFhTEnhs69D7KFemVH1gaz4=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs =
    [
      libgit2
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk_11_0.frameworks;
      [
        CoreFoundation
        IOKit
        SystemConfiguration
        Security
      ]
    );

  env = {
    LIBGIT2_NO_VENDOR = 1;
    OPENSSL_NO_VENDOR = 1;
  };

  # As the version is updated, the number of failed tests continues to grow.
  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
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
    maintainers = with maintainers; [
      aaronjheng
      edmundmiller
    ];
    mainProgram = "pixi";
  };
}
