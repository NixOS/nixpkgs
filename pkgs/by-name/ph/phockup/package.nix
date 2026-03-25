{
  lib,
  stdenv,
  python3,
  fetchFromGitHub,
  exiftool,
  makeWrapper,
}:
let
  pythonEnv = python3.withPackages (p: with p; [ tqdm ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "phockup";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "ivandokov";
    repo = "phockup";
    rev = finalAttrs.version;
    sha256 = "sha256-44UjxTbC2XK+NThvesROdd7aGP7zr7g7bQiQZv2TvvM=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    # based roughly on https://github.com/ivandokov/phockup#linux-without-snap
    mkdir -p $out/bin $out/opt
    mv * $out/opt
    makeWrapper ${pythonEnv.interpreter} $out/bin/phockup --add-flags "$out/opt/phockup.py" --suffix PATH : ${lib.makeBinPath [ exiftool ]}

    runHook postInstall
  '';

  meta = {
    description = "Media sorting tool to organize photos and videos from your camera in folders by year, month and day";
    homepage = "https://github.com/ivandokov/phockup";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aanderse ];
    mainProgram = "phockup";
  };
})
