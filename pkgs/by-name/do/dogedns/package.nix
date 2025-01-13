{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, pkg-config
, openssl
, pandoc
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "dogedns";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "Dj-Codeman";
    repo = "doge";
    rev = "v${version}";
    hash = "sha256-3wOka+MKSy2x3100eF0d9A5Jc0qFSNCiLsisHO1Uldc=";
  };

  cargoHash = "sha256-hRtHjyOeIGx7ulXZiyY7EWXVQiF2vzFP1Gf+lTpe2GQ=";

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

  nativeBuildInputs = [ installShellFiles pandoc ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.Security ];

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
