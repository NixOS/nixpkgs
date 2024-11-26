{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "certinfo-go";
  version = "0.1.36";

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "certinfo";
    rev = "refs/tags/v${version}";
    hash = "sha256-ySXp5dPdGhBEbo9uvCsINCufhm9j/dIX0Jn+Ou73NjM=";
  };

  vendorHash = "sha256-wrz33FSBz4Kg9aYCj7/Pq07bP73MV9iSQKc3X39OkHc=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    changelog = "https://github.com/paepckehh/certinfo/releases/tag/v${version}";
    homepage = "https://paepcke.de/certinfo";
    description = "Tool to analyze and troubleshoot x.509 & ssh certificates, encoded keys, ...";
    license = lib.licenses.bsd3;
    mainProgram = "certinfo";
    maintainers = with lib.maintainers; [ paepcke ];
  };
}
