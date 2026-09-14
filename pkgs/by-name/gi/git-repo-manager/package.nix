{
  pkgs,
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {

  pname = "git-repo-manager";
  version = "0.7.16";

  src = fetchFromGitHub {
    owner = "hakoerber";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-v8fgTrvgaYQzVDoxfREdkCR/1Kjv4f4mKlCLxXOjkHk=";
  };

  cargoSha256 = "sha256-APq8qq9B+GOyFiA0uquSB+e8SL1sgxVn6+ZOW2gnZHE=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = {
    description = "Git tool to manage worktrees and integrate with GitHub and GitLab";
    homepage = "https://hakoerber.github.io/git-repo-manager";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ cameronfyfe ];
    mainProgram = "grm";
  };
}
