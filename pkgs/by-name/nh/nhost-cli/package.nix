{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "nhost-cli";
  version = "1.42.1";

  src = fetchFromGitHub {
    owner = "nhost";
    repo = "nhost";
    tag = "cli@${finalAttrs.version}";
    hash = "sha256-n61YgU1/Ad1NMZr/1/jnmuZpN8PemPUW/gomf+ETvRw=";
  };

  sourceRoot = "${finalAttrs.src.name}/cli";

  vendorHash = null;

  ldflags = [
    "-s"
    "-X=main.Version=v${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/cli $out/bin/nhost
  '';

  # require network access
  checkFlags = [ "-skip=^TestMakeJSONRequest$" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Tool for setting up a local development environment for Nhost";
    homepage = "https://github.com/nhost/cli";
    changelog = "https://github.com/nhost/nhost/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "nhost";
  };
})
