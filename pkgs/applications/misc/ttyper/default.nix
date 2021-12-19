{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "ttyper";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "max-niederman";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UptjgFGp4QNG8eLuqBzg/Kd5p5Rms3yT172hbf/2hi4=";
  };

  cargoSha256 = "sha256-N10X5eJlpDKmCEffEXpkAejS32Lz183Lup0mmLMwOSU=";

  meta = with lib; {
    description = "Terminal-based typing test";
    homepage = "https://github.com/max-niederman/ttyper";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
