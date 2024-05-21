{
  rustPlatform,
  fetchCrate,
  fetchFromGitHub,
  lib,
  makeWrapper,
  hvm,
}:

rustPlatform.buildRustPackage rec {
  pname = "Bend";
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "HigherOrderCO";
    repo = "Bend";
    rev = "refs/tags/${version}";
    hash = "sha256-MEfB2SBJN7uEwfZGoEL7DQXsr1fccdZyGyzHtNv9wow=";
  };

  cargoHash = "sha256-+i+Y3MgCBVN3REmPwAjm2SiF9FJ0i05czmPKB8JtAFM=";

  RUSTC_BOOTSTRAP = true;

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
