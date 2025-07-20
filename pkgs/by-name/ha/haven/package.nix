{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "haven";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "bitvora";
    repo = "haven";
    tag = "v${version}";
    hash = "sha256-ddOZydweF3wVH81Bm8LIuP2HHGrGooIDeAH/Ro5LKu4=";
  };

  vendorHash = "sha256-JJ5kcTgjMB9d5JdMg2FiOOoAFeDhcEAsxWynd1aGNfs=";

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
