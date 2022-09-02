{ lib
, stdenv
, fetchFromGitHub
, SystemConfiguration
, installShellFiles
, libiconv
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "pueue";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "Nukesor";
    repo = "pueue";
    rev = "v${version}";
    hash = "sha256-xUTkjj/PdlgDEp2VMwBuRtF/9iGGiN4FZizdOdcbTag=";
  };

  cargoSha256 = "sha256-7VdPu+9RYoj4Xfb3J6GLOji7Fqxkk+Fswi4C4q33+jk=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [
    SystemConfiguration
    libiconv
  ];

  checkFlags = [
    "--test client_tests"
    "--skip=test_single_huge_payload"
    "--skip=test_create_unix_socket"
  ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/pueue completions $shell .
    done
    installShellCompletion pueue.{bash,fish} _pueue
  '';

  meta = with lib; {
    homepage = "https://github.com/Nukesor/pueue";
    description = "A daemon for managing long running shell commands";
    longDescription = ''
      Pueue is a command-line task management tool for sequential and parallel
      execution of long-running tasks.

      Simply put, it's a tool that processes a queue of shell commands. On top
      of that, there are a lot of convenient features and abstractions.

      Since Pueue is not bound to any terminal, you can control your tasks from
      any terminal on the same machine. The queue will be continuously
      processed, even if you no longer have any active ssh sessions.
    '';
    changelog = "https://github.com/Nukesor/pueue/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
