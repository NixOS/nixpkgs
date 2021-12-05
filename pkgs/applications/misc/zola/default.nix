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
}:

rustPlatform.buildRustPackage rec {
  pname = "zola";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "getzola";
    repo = "zola";
    rev = "v${version}";
    sha256 = "152ydi2gxfhyqsw6i79f9h1xwvwfq729likbagjy5z2bv822m44v";
  };

  cargoSha256 = "0bv2yyqy9l896p0dk1668ayw3xf71h9ddyymimx44j6nw389fxx3";

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

  meta = with lib; {
    description = "A fast static site generator with everything built-in";
    homepage = "https://www.getzola.org/";
    changelog = "https://github.com/getzola/zola/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dandellion dywedir _0x4A6F ];
    # set because of unstable-* version
    mainProgram = "zola";
  };
}
