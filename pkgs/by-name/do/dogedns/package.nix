{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  pkg-config,
  openssl,
  pandoc,
}:

rustPlatform.buildRustPackage rec {
  pname = "dogedns";
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "Dj-Codeman";
    repo = "doge";
    rev = "v${version}";
    hash = "sha256-SeC/GZ1AeEqRzxWc4oJ6JOvXfn3/LRcQz9uWXXqdTqU=";
  };

  cargoHash = "sha256-vLdfmaIOSxNqs1Hq6NJMA8HDZas4E9rc+VHnFSlX/wg=";

  patches = [
    # remove date info to make the build reproducible
    # remove commit hash to avoid dependency on git and the need to keep `.git`
    ./remove-date-info.patch
  ];

  checkFlags = [
    "--skip=options::test::all_mixed_3"
    "--skip=options::test::domain_and_class"
    "--skip=options::test::domain_and_class_lowercase"
    "--skip=options::test::domain_and_nameserver"
    "--skip=options::test::domain_and_single_domain"
    "--skip=options::test::just_domain"
    "--skip=options::test::just_named_domain"
    "--skip=options::test::two_classes"
  ];

  nativeBuildInputs = [
    installShellFiles
    pandoc
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ openssl ];

  postInstall = ''
    installShellCompletion completions/doge.{bash,fish,zsh}
    installManPage ./target/man/*.1
  '';

  meta = {
    description = "Reviving a command-line DNS client";
    homepage = "https://github.com/Dj-Codeman/doge";
    license = lib.licenses.eupl12;
    mainProgram = "doge";
    maintainers = with lib.maintainers; [ aktaboot ];
  };
}
