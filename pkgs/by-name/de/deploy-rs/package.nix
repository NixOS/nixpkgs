{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "deploy-rs";
  version = "0-unstable-2026-02-02";

  src = fetchFromGitHub {
    owner = "serokell";
    repo = "deploy-rs";
    rev = "77c906c0ba56aabdbc72041bf9111b565cdd6171";
    hash = "sha256-hwsYgDnby50JNVpTRYlF3UR/Rrpt01OrxVuryF40CFY=";
  };

  cargoHash = "sha256-9O93YTEz+e2oxenE0gwxsbz55clbKo9+37yVOqz7ErE=";

  meta = {
    description = "Multi-profile Nix-flake deploy tool";
    homepage = "https://github.com/serokell/deploy-rs";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      teutat3s
      jk
    ];
    mainProgram = "deploy";
  };
}
