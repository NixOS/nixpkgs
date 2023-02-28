{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, cmake
, pkg-config
, openssl
, oniguruma
, CoreServices
, installShellFiles
, libsass
, zola
, testers
}:

rustPlatform.buildRustPackage rec {
  pname = "zola";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "getzola";
    repo = "zola";
    rev = "v${version}";
    sha256 = "sha256-eS2u9wfU3BZ/2LMNmvbfve41y4X/x1COS1xG2BXSKEs=";
  };

  cargoSha256 = "sha256-Q7cDL6HP2ZujRoc1QCJPbXHHQlLeQq5J2XwJnNbTZxY=";

  nativeBuildInputs = [
    cmake
    pkg-config
    installShellFiles
  ];
  buildInputs = [
    openssl
    oniguruma
    libsass
  ] ++ lib.optionals stdenv.isDarwin [
    CoreServices
  ];

  RUSTONIG_SYSTEM_LIBONIG = true;

  postInstall = ''
    installShellCompletion --cmd zola \
      --bash <($out/bin/zola completion bash) \
      --fish <($out/bin/zola completion fish) \
      --zsh <($out/bin/zola completion zsh)
  '';

  passthru.tests.version = testers.testVersion { package = zola; };

  meta = with lib; {
    description = "A fast static site generator with everything built-in";
    homepage = "https://www.getzola.org/";
    changelog = "https://github.com/getzola/zola/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dandellion dywedir _0x4A6F ];
  };
}
