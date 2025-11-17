{
  fetchFromGitHub,
  lib,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

let
  pname = "parse-changelog";
  version = "0.6.12";
in

rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "taiki-e";
    repo = "parse-changelog";
    tag = "v${version}";
    hash = "sha256-KZYwlzcsUoc15ThJ/gYjdQYBFWWMAWU8YcgHa1oghfc=";
  };

  # NOTE(pigeonf): parse-changelog 0.6.12 uses a git dependency in its `dev-dependencies`, so we
  # cannot use the `Cargo.lock` from crates.io.
  postUnpack = ''
    ln -s ${./Cargo.lock} source/Cargo.lock
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;

    outputHashes = {
      "criterion-0.3.5" = "sha256-vasRbZPzun4W+T9MxJDFOYGpGAHgrFS7hQh86bAmet8=";
      "test-helper-0.0.0" = "sha256-VWVEi6BTbnH/PYdZnvvtlVxsNve/+SRKWJrgrRjakmQ=";
    };
  };

  useFetchCargoVendor = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--generate-lockfile" ];
  };

  meta = {
    homepage = "https://github.com/taiki-e/parse-changelog";
    changelog = "https://github.com/taiki-e/parse-changelog/blob/v${version}/CHANGELOG.md";
    description = "Simple changelog parser, written in Rust";
    mainProgram = "parse-changelog";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      pigeonf
    ];
  };
}
