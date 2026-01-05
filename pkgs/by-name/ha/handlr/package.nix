{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  shared-mime-info,
  libiconv,
  installShellFiles,
}:

rustPlatform.buildRustPackage {
  pname = "handlr";
  version = "unstable-2021-08-29";

  src = fetchFromGitHub {
    owner = "chmln";
    repo = "handlr";
    rev = "90e78ba92d0355cb523abf268858f3123fd81238";
    sha256 = "sha256-wENhlUBwfNg/r7yMKa1cQI1fbFw+qowwK8EdO912Yys=";
  };

  cargoHash = "sha256-/Kk2vuFkgtHarLrjqc5PkRZL2pV1Y7Gb02mWwtaVpDI=";

  nativeBuildInputs = [
    installShellFiles
    shared-mime-info
  ];
  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  preCheck = ''
    export HOME=$TEMPDIR
  '';

  postInstall = ''
    installShellCompletion \
      --zsh  completions/_handlr \
      --bash  completions/handlr \
      --fish completions/handlr.fish
  '';

  meta = with lib; {
    description = "Alternative to xdg-open to manage default applications with ease";
    homepage = "https://github.com/chmln/handlr";
    license = licenses.mit;
    maintainers = with maintainers; [ artturin ];
    mainProgram = "handlr";
  };
}
