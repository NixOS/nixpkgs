{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "proxify";
  version = "0.0.15";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "proxify";
    rev = "refs/tags/v${version}";
    hash = "sha256-vAI8LKdBmujH7zidXADc8bMLXaFMjT965hR+PVZVeNw=";
  };

  vendorHash = "sha256-eGcCc83napjt0VBhpDiHWn7+ew77XparDJ9uyjF353w=";

  meta = with lib; {
    description = "Proxy tool for HTTP/HTTPS traffic capture";
    longDescription = ''
      This tool supports multiple operations such as request/response dump, filtering
      and manipulation via DSL language, upstream HTTP/Socks5 proxy. Additionally a
      replay utility allows to import the dumped traffic (request/responses with correct
      domain name) into other tools by simply setting the upstream proxy to proxify.
    '';
    homepage = "https://github.com/projectdiscovery/proxify";
    changelog = "https://github.com/projectdiscovery/proxify/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
