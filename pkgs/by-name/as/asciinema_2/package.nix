{
  lib,
  fetchFromGitHub,
  python3Packages,
  testers,
}:

let
  self = python3Packages.buildPythonApplication {
    pname = "asciinema";
    version = "2.4.0";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "asciinema";
      repo = "asciinema";
      rev = "v${self.version}";
      hash = "sha256-UegLwpJ+uc9cW3ozLQJsQBjIGD7+vzzwzQFRV5gmDmI=";
    };

    build-system = [ python3Packages.setuptools ];

    nativeCheckInputs = [ python3Packages.pytestCheckHook ];

    postPatch = ''
      substituteInPlace tests/pty_test.py \
        --replace-fail "python3" "${python3Packages.python.interpreter}"
    '';

    strictDeps = true;

    passthru = {
      tests.version = testers.testVersion {
        package = self;
        command = ''
          export HOME=$TMP
          asciinema --version
        '';
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
      maintainers = with lib.maintainers; [ AndersonTorres ];
    };
  };
in
self
