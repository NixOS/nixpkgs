{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "atproto-goat";
<<<<<<< HEAD
  version = "0.2.1";
=======
  version = "0.1.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "bluesky-social";
    repo = "goat";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-ECkazbwg25L8W8w7B6hlKD1rEAjGBRKaZ76rKSfR0vI=";
=======
    hash = "sha256-xbvSO3keFheklnzPNEceS01CjIG3pPB+8e2M+3PD85U=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace main.go \
      --replace-fail "versioninfo.Short()" '"${finalAttrs.version}"' \
      --replace-fail '"github.com/earthboundkid/versioninfo/v2"' ""
  '';

<<<<<<< HEAD
  vendorHash = "sha256-t35Y+llIr2vpBr/LA6WurqxUH7fVTgT9Y8OHX8v8xP4=";
=======
  vendorHash = "sha256-hLsMme054E23NV8GDHsmZTYh/vY/w8gKWvpVIPeAiCY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Go AT protocol CLI tool";
    homepage = "https://github.com/bluesky-social/goat/blob/main/README.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "goat";
  };
})
