{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "proxify";
  version = "0.0.16";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "proxify";
    tag = "v${version}";
    hash = "sha256-CctbeKMf4+E+Fh/0hWLwHdTTsAavkiJ2ziMumY/+oF8=";
  };

  vendorHash = "sha256-7bOnLv2IJ9tysvZm33wBeMHvdSBDg1ii/QXv2n1wqxw=";

  meta = {
    description = "Proxy tool for HTTP/HTTPS traffic capture";
    longDescription = ''
      This tool supports multiple operations such as request/response dump, filtering
      and manipulation via DSL language, upstream HTTP/Socks5 proxy. Additionally a
      replay utility allows to import the dumped traffic (request/responses with correct
      domain name) into other tools by simply setting the upstream proxy to proxify.
    '';
    homepage = "https://github.com/projectdiscovery/proxify";
    changelog = "https://github.com/projectdiscovery/proxify/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
