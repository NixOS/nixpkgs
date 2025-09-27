{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "haven";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "bitvora";
    repo = "haven";
    tag = "v${version}";
    hash = "sha256-2947XUAppZ3DLA5A4U6D/4O9pZQfCsPxjRn/4iHkrCg=";
  };

  vendorHash = "sha256-kcy18MDwb4pPwtJmHi7Riw9/+Rs47VrVIIXKbfnv1DI=";

  postInstall = ''
    mkdir -p $out/share/haven
    cp -r $src/templates $out/share/haven/
    cp $src/.env.example $out/share/haven/.env.example
  '';

  meta = {
    description = "High Availability Vault for Events on Nostr";
    homepage = "https://github.com/bitvora/haven";
    changelog = "https://github.com/bitvora/haven/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felixzieger ];
    mainProgram = "haven";
  };
}
