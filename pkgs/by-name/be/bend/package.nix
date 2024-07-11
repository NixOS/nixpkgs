{
  rustPlatform,
  fetchFromGitHub,
  lib,
  makeWrapper,
  hvm,
}:

rustPlatform.buildRustPackage rec {
  pname = "Bend";
  version = "0.2.34";

  src = fetchFromGitHub {
    owner = "HigherOrderCO";
    repo = "Bend";
    rev = "refs/tags/${version}";
    hash = "sha256-3leAt1M3Six5+KcCcz7sorpVHGkKj7xGWZ0KJnh+bNs=";
  };

  cargoHash = "sha256-VynLnpZLUCqclIlbt7y6kd8ZJQGLa892J2UjDATgAhE=";

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
