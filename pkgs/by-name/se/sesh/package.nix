{
  lib,
  fetchFromGitHub,
  buildGoModule,
  go-mockery,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
buildGoModule (finalAttrs: {
  pname = "sesh";
  version = "2.24.2";

  nativeBuildInputs = [
    go-mockery
    writableTmpDirAsHomeHook
  ];

  src = fetchFromGitHub {
    owner = "joshmedeski";
    repo = "sesh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iisAIn4km/uFw2DohA2mjoYmKgDQ3lYUH284Le3xQD0=";
  };

  # NOTE: prevent crash when getting vendor deps/hash
  overrideModAttrs = _: {
    preBuild = "";
  };

  preBuild = ''
    mockery
  '';

  vendorHash = "sha256-WHMQ7O5EZ43biR7HxjO9gUq8skFPCZVOx47NIPp5iSE=";

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
