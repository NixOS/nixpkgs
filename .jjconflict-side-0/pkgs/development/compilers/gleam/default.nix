{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  git,
  pkg-config,
  openssl,
  erlang,
  Security,
  nix-update-script,
  SystemConfiguration,
}:

rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-r+iN6eLmy6qnrhvHKUQufd/4mvZL9TCVaqLqEPcLu1E=";
  };

  nativeBuildInputs = [
    git
    pkg-config
  ];

  buildInputs =
    [
      openssl
      erlang
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Security
      SystemConfiguration
    ];

  cargoHash = "sha256-+kKKdNAvr8sTaFvzCCpY1bVS779DgJbHI9kUUIi4lXE=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Statically typed language for the Erlang VM";
    mainProgram = "gleam";
    homepage = "https://gleam.run/";
    changelog = "https://github.com/gleam-lang/gleam/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = teams.beam.members ++ [ lib.maintainers.philtaken ];
  };
}
