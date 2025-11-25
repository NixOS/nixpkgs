{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  libiconv,
}:

rustPlatform.buildRustPackage rec {
  pname = "procs";
  version = "0.14.10";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "procs";
    rev = "v${version}";
    hash = "sha256-+qY0BG3XNCm5vm5W6VX4a0JWCb4JSat/oK9GLXRis/M=";
  };

  cargoHash = "sha256-/y+9EA3PhyI5iqg2wM0ny41nBDJiKnsjvbmPfCe5RJk=";

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ rustPlatform.bindgenHook ];

  postInstall = ''
    for shell in bash fish zsh; do
      ${stdenv.hostPlatform.emulator buildPackages} $out/bin/procs --gen-completion $shell
    done
    installShellCompletion procs.{bash,fish} --zsh _procs
  '';

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  meta = {
    description = "Modern replacement for ps written in Rust";
    homepage = "https://github.com/dalance/procs";
    changelog = "https://github.com/dalance/procs/raw/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Br1ght0ne
      sciencentistguy
    ];
    mainProgram = "procs";
  };
}
