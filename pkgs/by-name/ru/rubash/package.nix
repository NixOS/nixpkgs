{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rubash";
  version = "1.5.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "unixwin";
    repo = "rubash";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xsPCBoTdrVylbP5i+sQGh39WaImu+4ee0aSFzzxbCoI=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-FZ4yiWJJpkWecsprCvIE+pFla9WOddYRHpqjGHWw+KQ=";

  doCheck = false; # Tests are running too slow.

  passthru = {
    shellPath = "/bin/rubash";
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Rust GNU Bash compatible shell engine with no POSIX emulation layer";
    homepage = "https://github.com/unixwin/rubash";
    changelog = "https://github.com/unixwin/rubash/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eveeifyeve ];
    mainProgram = "rubash";
  };
})
