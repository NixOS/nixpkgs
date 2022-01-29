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
, testVersion
}:

rustPlatform.buildRustPackage rec {
  pname = "zola";
  version = "0.15.3";

  src = fetchFromGitHub {
    owner = "getzola";
    repo = "zola";
    rev = "v${version}";
    sha256 = "sha256-LK8twqWaS+SQ3oqvMGE7oP/IJNLvQ45Pu92pkbSKzDs=";
  };

  cargoSha256 = "sha256-7W0vjbAWZl/eKBZvUWWWolEOh8aQeKegt823EebcKMQ=";

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

  passthru.tests.version = testVersion { package = zola; };

  meta = with lib; {
    description = "A fast static site generator with everything built-in";
    homepage = "https://www.getzola.org/";
    changelog = "https://github.com/getzola/zola/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dandellion dywedir _0x4A6F ];
  };
}
