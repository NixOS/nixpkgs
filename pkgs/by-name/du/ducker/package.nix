{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ducker";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "robertpsoane";
    repo = "ducker";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-ly5+2GySq2yiEDXG+IXfAB70Wzp58B+Py0GCuvwKXxw=";
  };

  cargoHash = "sha256-Sgn7dxmt/kn40jqMcRUIxdLfJRDWrHEAUb3TXUuGqSk=";

  meta = {
    description = "Terminal app for managing docker containers, inspired by K9s";
    homepage = "https://github.com/robertpsoane/ducker";
    changelog = "https://github.com/robertpsoane/ducker/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "ducker";
    platforms = with lib.platforms; unix ++ windows;
    maintainers = with lib.maintainers; [ anas ];
  };
})
