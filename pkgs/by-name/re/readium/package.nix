{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "readium";
  version = "0.9.1";
  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "readium";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D7Qpf+6qMdXWQ35zdIBZTVpT6zJEK7TVpjpLDPg+/n0=";
  };

  vendorHash = "sha256-Jph5NafR7PSrH2ub+85Cd/QxHPi6UyvyDJdlfsJrQNw=";

  ldflags = [ "-X=github.com/readium/cli/internal/version.Version=v${finalAttrs.version}" ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/readium
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "CLI utility with support for a wide range of commands for ebooks, comics and audiobooks";
    homepage = "https://github.com/readium/cli/";
    changelog = "https://github.com/readium/cli/blob/develop/CHANGELOG.MD";
    license = lib.licenses.bsd3;
    mainProgram = "readium";
    maintainers = with lib.maintainers; [ CodeF53 ];
  };
})
