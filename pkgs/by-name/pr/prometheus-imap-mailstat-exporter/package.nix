{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "imap-mailstat-exporter";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "bt909";
    repo = "imap-mailstat-exporter";
    tag = "${version}";
    hash = "sha256-lJ0ceeCmk27LGmXVmkFvJ8fQlV51Nw6uZNJdXw+1BfU=";
  };

  vendorHash = "sha256-cppTGZvG/tq5nd5gZho9Oxfsits8PECuXmN1CFhquVg=";

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
