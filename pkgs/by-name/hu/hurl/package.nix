{ lib
, rustPlatform
, fetchFromGitHub
, fetchpatch
, pkg-config
, installShellFiles
, libxml2
, openssl
, stdenv
, curl
}:

rustPlatform.buildRustPackage rec {
  pname = "hurl";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "Orange-OpenSource";
    repo = pname;
    rev = version;
    hash = "sha256-gSkiNwRR47CZ1YjVa5o8EByCzWBAYPfsMRXydTwFwp0=";
  };

  cargoHash = "sha256-dY00xcMnOCWhdRzC+3mTHSIqeYEPUDBJeYd/GiLM/38=";

  patches = [
    # Fix for rust 1.79, see https://github.com/Orange-OpenSource/hurl/issues/3057
    # We should be able to remove this at the next hurl version bump
    (fetchpatch {
      name = "hurl-fix-rust-1.79";
      url = "https://github.com/Orange-OpenSource/hurl/commit/d51c275fc63d1ee5bbdc6fc70279ec8dae86a9c1.patch";
      hash = "sha256-peA4Zq5J8ynL7trvydQ3ZqyHpJWrRmJeFeMKH9XT2n4=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    libxml2
    openssl
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    curl
  ];

  # Tests require network access to a test server
  doCheck = false;

  postInstall = ''
    installManPage docs/manual/hurl.1 docs/manual/hurlfmt.1
    installShellCompletion --cmd hurl \
      --bash completions/hurl.bash \
      --zsh completions/_hurl \
      --fish completions/hurl.fish

    installShellCompletion --cmd hurlfmt \
      --zsh completions/_hurlfmt
  '';

  meta = with lib; {
    description = "Command line tool that performs HTTP requests defined in a simple plain text format";
    homepage = "https://hurl.dev/";
    changelog = "https://github.com/Orange-OpenSource/hurl/blob/${version}/CHANGELOG.md";
    maintainers = with maintainers; [ eonpatapon figsoda ];
    license = licenses.asl20;
    mainProgram = "hurl";
  };
}
