{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mutagen-compose";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "mutagen-io";
    repo = "mutagen-compose";
    rev = "v${version}";
    hash = "sha256-MK/icz/d7wymUm0m3aq4bBR1ZmxFngPVp+iPC9ufluU=";
  };

  vendorHash = "sha256-+lF59qWdC5hnVehM0EDR1pyKXmodtWJSUVIfAIlAWeA=";

  doCheck = false;

  subPackages = [ "cmd/mutagen-compose" ];

  tags = [ "mutagencompose" ];

  meta = with lib; {
    description = "Compose with Mutagen integration";
    homepage = "https://mutagen.io/";
    changelog = "https://github.com/mutagen-io/mutagen-compose/releases/tag/v${version}";
    maintainers = [ maintainers.matthewpi ];
    license = licenses.mit;
    mainProgram = "mutagen-compose";
  };
}
