{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libx11,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "nerdlog";
  version = "1.10.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dimonomid";
    repo = "nerdlog";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XlzWNeyd+Ar4ArFcN1wkQ0aod6ckAiIb12odK7cf4+s=";
  };

  vendorHash = "sha256-hvv0dsE1yz85VLaBOE7RWbux8L8kVTihcA1HyyHRYAM=";

  buildInputs = [ libx11 ];

  subPackages = [ "cmd/nerdlog" ];

  ldflags = [
    "-X github.com/dimonomid/nerdlog/version.version=${finalAttrs.version}"
    "-X github.com/dimonomid/nerdlog/version.builtBy=nix"
  ];

  # e2e tests require SSH connections to test hosts
  checkFlags = [
    "-skip"
    "^TestE2E"
  ];

  doInstallCheck = true;
  nativeBuildInputs = [ versionCheckHook ];

  # `nerdlog --version` will fail if $HOME is not defined
  versionCheckKeepEnvironment = [ "HOME" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/dimonomid/nerdlog/releases/tag/${finalAttrs.src.tag}";
    description = "Fast, remote-first, multi-host TUI log viewer with timeline histogram";
    longDescription = ''
      Nerdlog is a fast, remote-first, multi-host TUI log viewer with timeline histogram
      and no central server. Loosely inspired by Graylog/Kibana, but without the bloat.
      Pretty much no setup needed, either.
    '';
    homepage = "https://github.com/dimonomid/nerdlog";
    license = lib.licenses.bsd2;
    mainProgram = "nerdlog";
    maintainers = with lib.maintainers; [ tophcodes ];
  };
})
