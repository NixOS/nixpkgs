{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "imap-mailstat-exporter";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "bt909";
    repo = "imap-mailstat-exporter";
    tag = "${version}";
    hash = "sha256-Q+Q7Q9zjJlp83FQ65yqi8eWO02+VkCXlYFRA66yptiE=";
  };

  vendorHash = "sha256-9rxlXhlQ269E6xtreMrDphqscaZj+IrfsNmssF/C78U=";

  nativeBuildInputs = [ installShellFiles ];

  meta = {
    description = "Export Prometheus-style metrics about how many emails you have in your INBOX and in additional configured folders";
    mainProgram = "imap-mailstat-exporter";
    homepage = "https://github.com/bt909/imap-mailstat-exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ raboof ];
    platforms = lib.platforms.linux;
  };
}
