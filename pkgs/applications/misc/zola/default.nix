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
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "getzola";
    repo = "zola";
    rev = "v${version}";
    sha256 = "sha256-FrCpHavlHf4/g96G7cY0Rymxqi73XUCIAYp4cm//2Ic=";
  };

  cargoSha256 = "sha256-c6SbQasgpOyqVninAo104oYo1CXpiECZvsB1gxrD7wM=";

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
      --fish completions/zola.fish \
      --zsh completions/_zola \
      --bash completions/zola.bash
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
