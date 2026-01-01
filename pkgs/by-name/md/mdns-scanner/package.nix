{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdns-scanner";
<<<<<<< HEAD
  version = "0.26.0";
=======
  version = "0.25.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "CramBL";
    repo = "mdns-scanner";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-CUaJ2TZGOnb+ebckvKzQFhUx/B+BU1Wu8cr247VE4Pg=";
  };

  cargoHash = "sha256-Lb24qEiIMbatzKY9YQgQRrsRBp/An4ADalNY8zG5Mr0=";
=======
    hash = "sha256-Q8xJ1RmJCaeqbCS5pRnV2kvfyLh1Mx7r+aU0HRbkBvY=";
  };

  cargoHash = "sha256-fUauhWqAv7Ce4nmbsmVoWJBAG+M0IgtOU7nU8F0u540=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    homepage = "https://github.com/CramBL/mdns-scanner";
    description = "Scan a network and create a list of IPs and associated hostnames, including mDNS hostnames and other aliases";
    changelog = "https://github.com/CramBL/mdns-scanner/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ Cameo007 ];
    mainProgram = "mdns-scanner";
  };
})
