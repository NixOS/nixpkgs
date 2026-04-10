{
  lib,
  fetchFromGitHub,
  rustPlatform,
  testers,
  fsrx,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fsrx";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "thatvegandev";
    repo = "fsrx";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-hzfpjunP20WCt3erYu7AO7A3nz+UMKdFzWUA5jASbVA=";
  };

  cargoHash = "sha256-hOE05t3gjul7uOt14vr5hAmGHTPgxJk7EOKJhZ4XgCo=";

  passthru = {
    tests.version = testers.testVersion {
      package = fsrx;
    };
  };

  meta = {
    description = "Flow state reader in the terminal";
    homepage = "https://github.com/thatvegandev/fsrx";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ MoritzBoehme ];
    mainProgram = "fsrx";
  };
})
