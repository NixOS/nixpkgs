{
  rustPlatform,
  fetchFromGitHub,
  lib,
  makeWrapper,
  hvm,
}:

rustPlatform.buildRustPackage rec {
  pname = "Bend";
  version = "0.2.36";

  src = fetchFromGitHub {
    owner = "HigherOrderCO";
    repo = "Bend";
    rev = "refs/tags/${version}";
    hash = "sha256-j4YMdeSxIbhp7xT42L42/y0ZncFPKBkxTh0LgO/RjkY=";
  };

  cargoHash = "sha256-jPxPx/e6rv5REP+K1ZLg9ffJKKVNLqR/vd33xKs+Ut4=";

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
