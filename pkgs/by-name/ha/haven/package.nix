{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "haven";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "bitvora";
    repo = "haven";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1rGOZVzlzijyxqjAnp2uvxy9KPr3uuRD8+48x38lQwg=";
  };

  vendorHash = "sha256-VXx6uoOUKk/BkjDS3Ykf/0Xc2mUPm8dgyRArIb2I8X4=";

  postInstall = ''
    mkdir -p $out/share/haven
    cp -r $src/templates $out/share/haven/
    cp $src/.env.example $out/share/haven/.env.example
  '';

  meta = {
    description = "High Availability Vault for Events on Nostr";
    homepage = "https://github.com/bitvora/haven";
    changelog = "https://github.com/bitvora/haven/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felixzieger ];
    mainProgram = "haven";
  };
})
