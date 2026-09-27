{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "proxify";
  version = "0.0.16";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "proxify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CctbeKMf4+E+Fh/0hWLwHdTTsAavkiJ2ziMumY/+oF8=";
  };

  vendorHash = "sha256-7bOnLv2IJ9tysvZm33wBeMHvdSBDg1ii/QXv2n1wqxw=";

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  ldflags = [ "-s" ];

  doInstallCheck = true;

  versionCheckKeepEnvironment = [ "HOME" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Proxy tool for HTTP/HTTPS traffic capture";
    longDescription = ''
      This tool supports multiple operations such as request/response dump, filtering
      and manipulation via DSL language, upstream HTTP/Socks5 proxy. Additionally a
      replay utility allows to import the dumped traffic (request/responses with correct
      domain name) into other tools by simply setting the upstream proxy to proxify.
    '';
    homepage = "https://github.com/projectdiscovery/proxify";
    changelog = "https://github.com/projectdiscovery/proxify/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
