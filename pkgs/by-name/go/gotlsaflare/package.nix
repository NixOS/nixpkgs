{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gotlsaflare";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "Stenstromen";
    repo = "gotlsaflare";
    rev = "v${version}";
    hash = "sha256-T0HSf/66/IxjXWScsMQuimszzAgtNsH9ab9YjSsE8lQ=";
  };

  vendorHash = "sha256-m5mBubfbXXqXKsygF5j7cHEY+bXhAMcXUts5KBKoLzM=";

  meta = with lib; {
    description = "Update TLSA DANE records on cloudflare from x509 certificates";
    mainProgram = "gotlsaflare";
    homepage = "https://github.com/Stenstromen/gotlsaflare";
    license = licenses.mit;
    maintainers = with maintainers; [ szlend ];
    platforms = platforms.all;
  };
}
