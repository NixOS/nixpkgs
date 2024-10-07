{
  lib,
  fetchFromGitHub,
  makeWrapper,
  jujutsu,
  rustPlatform,
  testers,
  lazyjj,
}:
rustPlatform.buildRustPackage rec {
  pname = "lazyjj";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "Cretezy";
    repo = "lazyjj";
    rev = "v${version}";
    hash = "sha256-aglLPEps88D15iv3toNnhRC06gTuM6ITnvZDJg17u6M=";
  };

  cargoHash = "sha256-P5k7C18PP9/y5P5kKWpQcMnT4BeYpFT6IH+M1AgGaPw=";

  postInstall = ''
    wrapProgram $out/bin/lazyjj \
      --prefix PATH : ${lib.makeBinPath [ jujutsu ]}
  '';

  nativeBuildInputs = [ makeWrapper ];

  nativeCheckInputs = [ jujutsu ];

  passthru.tests.version = testers.testVersion { package = lazyjj; };

  meta = with lib; {
    description = "TUI for Jujutsu/jj";
    homepage = "https://github.com/Cretezy/lazyjj";
    mainProgram = "lazyjj";
    license = licenses.asl20;
    maintainers = with maintainers; [ colemickens ];
  };
}
