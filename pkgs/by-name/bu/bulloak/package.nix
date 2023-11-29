{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "bulloak";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "alexfertel";
    repo = "bulloak";
    rev = "v${version}";
    hash = "sha256-lUTMQMBqCezuUsfvuYSCBFsokoY3bPoJDGWL90EjVqY=";
  };

  cargoHash = "sha256-LH96e/dBbv4J7g7wzh3/vL+PzZn779zUMBgio6w3rJw=";

  # tests run in CI on the source repo
  doCheck = false;

  meta = with lib; {
    description = "A Solidity test generator based on the Branching Tree Technique";
    homepage = "https://github.com/alexfertel/bulloak";
    license = with licenses; [ mit asl20 ];
    mainProgram = "bulloak";
    maintainers = with maintainers; [ beeb ];
  };
}
