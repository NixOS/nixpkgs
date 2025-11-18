{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rq";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "dflemstr";
    repo = "rq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QyYTbMXikLSe3eYJRUALQJxUJjA6VlvaLMwGrxIKfZI=";
  };

  cargoHash = "sha256-BwbGiLoygNUua+AAKw/JAAG1kuWLdnP+8o+FFuvbFlM=";

  postPatch = ''
    # Remove #[deny(warnings)] which is equivalent to -Werror in C.
    # Prevents build failures when upgrading rustc, which may give more warnings.
    substituteInPlace src/lib.rs \
      --replace-fail "#![deny(warnings)]" ""

    # build script tries to get version information from git
    # this fixes the --version output
    rm build.rs
  '';

  VERGEN_SEMVER = finalAttrs.version;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Tool for doing record analysis and transformation";
    mainProgram = "rq";
    homepage = "https://github.com/dflemstr/rq";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ Br1ght0ne ];
  };
})
