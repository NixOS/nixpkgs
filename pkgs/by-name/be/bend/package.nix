{
  rustPlatform,
  fetchFromGitHub,
  lib,
  makeWrapper,
  hvm,
}:

rustPlatform.buildRustPackage rec {
  pname = "Bend";
  version = "0.2.37";

  src = fetchFromGitHub {
    owner = "HigherOrderCO";
    repo = "Bend";
    rev = "refs/tags/${version}";
    hash = "sha256-8uBEI9GKUETk8t6Oanb0OECe3MlJ486QnccOuhIxPuY=";
  };

  cargoHash = "sha256-GoBGsA8RCTIVMMHiAeRGJ+qPPNYrkPsBsOH0w1v6fgo=";

  nativeBuildInputs = [
    hvm
    makeWrapper
  ];

  postInstall = ''
    wrapProgram $out/bin/bend \
      --prefix PATH : ${lib.makeBinPath [ hvm ]}
  '';

  meta = {
    description = "Bend is a massively parallel, high-level programming language";
    homepage = "https://higherorderco.com/";
    license = lib.licenses.asl20;
    mainProgram = "bend";
    maintainers = with lib.maintainers; [ k3yss ];
    platforms = lib.platforms.unix;
  };
}
