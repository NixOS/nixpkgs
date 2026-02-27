{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "haven";
  version = "1.2.0-unstable-2026-02-27";

  src = fetchFromGitHub {
    owner = "barrydeen";
    repo = "haven";
    rev = "1f81770d3a79f8ebb2f037b37635ab66e02d13d8";
    hash = "sha256-4N7erObBg613aDFHRmjNE25eyQBPsenSz3JkQbdcki0=";
  };

  vendorHash = "sha256-VXx6uoOUKk/BkjDS3Ykf/0Xc2mUPm8dgyRArIb2I8X4=";

  postInstall = ''
    mkdir -p $out/share/haven
    cp -r $src/templates $out/share/haven/
    cp $src/.env.example $out/share/haven/.env.example
  '';

  meta = {
    description = "High Availability Vault for Events on Nostr";
    homepage = "https://github.com/barrydeen/haven";
    changelog = "https://github.com/barrydeen/haven/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felixzieger ];
    mainProgram = "haven";
  };
})
