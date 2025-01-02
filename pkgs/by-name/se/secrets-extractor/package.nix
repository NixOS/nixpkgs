{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
}:

buildGoModule rec {
  pname = "secrets-extractor";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "Xenios91";
    repo = "Secrets-Extractor";
    rev = "refs/tags/v${version}";
    hash = "sha256-xtxhatxNK9bRnT1R/5BJkTcubO58sg5ssrziLYvw6mQ=";
  };

  vendorHash = "sha256-1NfeFw8v6F00CZe8a3qdk/TrUBNi2wr9PvwIsZzkDSk=";

  buildInputs = [ libpcap ];

  meta = with lib; {
    description = "Tool to check packets for secrets";
    homepage = "https://github.com/Xenios91/Secrets-Extractor";
    # https://github.com/Xenios91/Secrets-Extractor/issues/1
    license = licenses.unfree;
    maintainers = with maintainers; [ fab ];
  };
}
