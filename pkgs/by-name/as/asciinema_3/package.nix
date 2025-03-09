{
  lib,
  fetchFromGitHub,
  python3,
  rustPlatform,
  testers,
}:

let
  self = rustPlatform.buildRustPackage {
    pname = "asciinema";
    version = "3.0.0-rc.3";

    src = fetchFromGitHub {
      name = "asciinema-source-${self.version}";
      owner = "asciinema";
      repo = "asciinema";
      rev = "v${self.version}";
      hash = "sha256-TYJ17uVj8v1u630MTb033h0X3aYRXY9d89GjAxG8muk=";
    };

    cargoHash = "sha256-CYDy0CedwG/ThTV+XOfOg8ncxF3tdTEGakmu4MXfiE4=";

    nativeCheckInputs = [ python3 ];

    checkFlags = [
      # ---- pty::tests::exec_quick stdout ----
      # thread 'pty::tests::exec_quick' panicked at src/pty.rs:494:10:
      # called `Result::unwrap()` on an `Err` value: EBADF: Bad file number
      "--skip=pty::tests::exec_quick"
    ];

    strictDeps = true;

    passthru = {
      tests.version = testers.testVersion {
        package = self;
        command = "asciinema --version";
      };
    };

    meta = {
      homepage = "https://asciinema.org/";
      description = "Terminal session recorder and the best companion of asciinema.org";
      longDescription = ''
        asciinema is a suite of tools for recording, replaying, and sharing
        terminal sessions. It is free and open-source software (FOSS), created
        by Marcin Kulik.

        Its typical use cases include creating tutorials, demonstrating
        command-line tools, and sharing reproducible bug reports. It focuses on
        simplicity and interoperability, which makes it a popular choice among
        computer users working with the command-line, such as developers or
        system administrators.
      '';
      license = with lib.licenses; [ gpl3Plus ];
      mainProgram = "asciinema";
      maintainers = with lib.maintainers; [ jiriks74 ];
    };
  };
in
self
