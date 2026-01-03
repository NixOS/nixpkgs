{
  lib,
  stdenv,
  fetchFromGitHub,
  writeShellScriptBin,
  skawarePackages,
}:

let
  version = "1.3.0";
  sha256 = "sha256-CFv9gZQHeEiZctJFyB6PJ1dVNkrQ7PlVtgZuteQQTJ0=";

in
stdenv.mkDerivation {
  pname = "git-vendor";
  inherit version;

  src = fetchFromGitHub {
    owner = "brettlangdon";
    repo = "git-vendor";
    rev = "v${version}";
    inherit sha256;
  };

  outputs = [
    "bin"
    "man"
    "doc"
    "out"
  ];

  PREFIX = (placeholder "out");
  BINPREFIX = "${placeholder "bin"}/bin";
  MANPREFIX = "${placeholder "man"}/share/man/man1";

  buildInputs = [
    # stubbing out a `git config` check that `make install` tries to do
    (writeShellScriptBin "git" "")
  ];

  postInstall = ''
    ${
      skawarePackages.cleanPackaging.commonFileActions {
        docFiles = [
          "LICENSE"
          "README.md"
        ];
        noiseFiles = [
          "bin/git-vendor"
          "Makefile"
          "etc/bash_completion.sh"
          "man"
          "install.sh"
        ];
      }
    } $doc/share/doc/git-vendor
  '';

  postFixup = ''
    ${skawarePackages.cleanPackaging.checkForRemainingFiles}
  '';

  meta = {
    description = "Git command for managing vendored dependencies";
    longDescription = ''
      git-vendor is a wrapper around git-subtree commands for checking out and updating vendored dependencies.

      By default git-vendor conforms to the pattern used for vendoring golang dependencies:
        * Dependencies are stored under vendor/ directory in the repo.
        * Dependencies are stored under the fully qualified project path.
            e.g. https://github.com/brettlangdon/forge will be stored under vendor/github.com/brettlangdon/forge.
    '';
    homepage = "https://github.com/brettlangdon/git-vendor";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProgram = "git-vendor";
  };

}
