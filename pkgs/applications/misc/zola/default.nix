{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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
  version = "0.17.2";

  src = fetchFromGitHub {
    owner = "getzola";
    repo = "zola";
    rev = "v${version}";
    hash = "sha256-br7VpxkVMZ/TgwMaFbnVMOw9RemNjur/UYnloMoDzHs=";
  };

  cargoHash = "sha256-AAub8UwAvX3zNX+SM/T9biyNxFTgfqUQG/MUGfwWuno=";

  patches = [
    (fetchpatch {
      name = "CVE-2023-40274.patch";
      url = "https://github.com/getzola/zola/commit/fe1967fb0fe063b1cee1ad48820870ab2ecc0e5b.patch";
      hash = "sha256-B/SVGhVX5hAbvMhBYO+mU5+xdZXU2JyS4uKmOj+aZuI=";
    })
  ];

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
