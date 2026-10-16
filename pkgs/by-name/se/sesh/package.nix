{
  lib,
  fetchFromGitHub,
  buildGo127Module,
  go-mockery,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
buildGo127Module (finalAttrs: {
  pname = "sesh";
  version = "2.33.0";
  __structuredAttrs = true;

  nativeBuildInputs = [
    go-mockery
    writableTmpDirAsHomeHook
  ];

  src = fetchFromGitHub {
    owner = "joshmedeski";
    repo = "sesh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q25fdn+1T4NOnFX5ZuIMhhRBFSj7dfjybgCj2bu3lK4=";
  };

  # NOTE: prevent crash when getting vendor deps/hash
  overrideModAttrs = _: {
    preBuild = "";
  };

  preBuild = ''
    mockery
  '';

  vendorHash = "sha256-8CMqOlq3rAXPpzABxd2pp2DhMOvKAN+jHVZ2bLZUN0w=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckKeepEnvironment = [ "HOME" ];
  doInstallCheck = true;

  meta = {
    description = "Smart session manager for the terminal";
    homepage = "https://github.com/joshmedeski/sesh";
    changelog = "https://github.com/joshmedeski/sesh/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      gwg313
      randomdude
      t-monaghan
    ];
    mainProgram = "sesh";
  };
})
