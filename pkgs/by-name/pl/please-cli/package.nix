{
  lib,
  curl,
  fetchFromGitHub,
  jq,
  makeBinaryWrapper,
  please-cli,
  stdenv,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "please-cli";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "TNG";
    repo = "please-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wgH/43CQ8LCOwoidv9ciOiquHKoWAB6qlpeKN/JdcEc=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm555 please.sh "$out/bin/please"
    wrapProgram $out/bin/please \
      --prefix PATH : ${
        lib.makeBinPath [
          curl
          jq
        ]
      }
    runHook postInstall
  '';

  passthru.tests = testers.testVersion {
    package = please-cli;
    version = "v${finalAttrs.version}";
  };

  meta = with lib; {
    description = "AI helper script to create CLI commands based on GPT prompts";
    homepage = "https://github.com/TNG/please-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ _8-bit-fox ];
    mainProgram = "please";
    platforms = platforms.all;
  };
})
