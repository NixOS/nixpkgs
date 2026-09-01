{
  lib,
  stdenv,
  fetchFromGitHub,
  ffmpeg,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gifgen";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "lukechilds";
    repo = "gifgen";
    rev = finalAttrs.version;
    hash = "sha256-ni9RL4LyMejmu8vm5HC8WSTqAPQMBQNRDOZ4ZfvrkSU=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 gifgen $out/bin/gifgen
    wrapProgram $out/bin/gifgen \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
    runHook postInstall
  '';

  meta = {
    description = "Simple high quality GIF encoding";
    homepage = "https://github.com/lukechilds/gifgen";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "gifgen";
    platforms = lib.platforms.all;
  };
})
