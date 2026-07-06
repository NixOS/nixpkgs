{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "imap-mailstat-exporter";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "bt909";
    repo = "imap-mailstat-exporter";
    tag = "${version}";
    hash = "sha256-dinHRHoTVc/0Lu+TzzmfoCyoDZQQhXw8AOlgbH46hm0=";
  };

  vendorHash = "sha256-k3FjfIaNm6408I4uqmJpZsGgMiHel+NUtBclbGKTtZ4=";

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
