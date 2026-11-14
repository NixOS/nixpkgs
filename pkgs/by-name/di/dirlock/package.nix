{
  lib,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  openssl,
  nix-update-script,
  systemdLibs,
  pam,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dirlock";
  version = "0-unstable-2026-09-16";
  __structuredAttrs = true;
  doCheck = false; # tests are impure, need at least: root or fakeroot,fs to run tests against, env vars

  src = fetchFromGitLab {
    domain = "gitlab.steamos.cloud";
    owner = "holo";
    repo = "dirlock";
    rev = "3a795b2516cbd78acd3ca28fa94a55220511558c";
    hash = "sha256-HyW8TZiW5xohFBHUkwvAf0ONVopcds7cT5sEh1/Mnbs=";
  };

  cargoHash = "sha256-IVJqpPYODcFo4f/fVJUrOuKmWB9IsLJH4a56l/i3x0Y=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    systemdLibs
    pam
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for managing encrypted directories using the Linux kernel's fscrypt API.";
    homepage = "https://gitlab.steamos.cloud/holo/dirlock";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nanashi ];
    mainProgram = "dirlock";
  };
})
