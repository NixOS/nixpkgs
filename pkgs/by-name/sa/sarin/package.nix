{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "sarin";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "aykhans";
    repo = "sarin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FOII7kTQW5ywBTQZaAtLVWii6yZPtQceK8tKkhg25Tw=";
  };

  vendorHash = "sha256-/r2mioVoMbrboumF0sjHhharkGImQAShmiOQtdS5DaE=";

  __structuredAttrs = true;

  subPackages = [ "cmd/cli" ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X=go.aykhans.me/sarin/internal/version.Version=v${finalAttrs.version}"
  ];

  # GoVersion is read from the build toolchain so it never drifts. The value
  # contains spaces, so it is single-quoted: `go build` splits -ldflags
  # shell-style and honours the quotes, keeping it as one -X value.
  preBuild = ''
    ldflags+=("-X 'go.aykhans.me/sarin/internal/version.GoVersion=$(go version)'")
  '';

  # cmd/cli produces a binary named "cli"; rename it to "sarin".
  postInstall = ''
    mv $out/bin/cli $out/bin/sarin
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "High-performance HTTP load testing tool built with Go and fasthttp";
    homepage = "https://github.com/aykhans/sarin";
    changelog = "https://github.com/aykhans/sarin/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "sarin";
    maintainers = with lib.maintainers; [ aykhans ];
  };
})
