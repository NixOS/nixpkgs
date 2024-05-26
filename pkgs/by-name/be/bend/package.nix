{
  rustPlatform,
  fetchFromGitHub,
  lib,
  makeWrapper,
  hvm,
}:

rustPlatform.buildRustPackage rec {
  pname = "Bend";
  version = "0.2.22";

  src = fetchFromGitHub {
    owner = "HigherOrderCO";
    repo = "Bend";
    rev = "refs/tags/${version}";
    hash = "sha256-5qcj3KfgcB5tbVSJUSOVQDAhEpPE8SFoT0g9syHbFCA=";
  };

  cargoHash = "sha256-gSAIidMEYJDZHgIWNgYJVqyhpD7M+CMCD+1mEXGztIk=";

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
