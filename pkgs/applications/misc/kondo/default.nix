{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "kondo";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "tbillington";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-f0eRM4U2FwMGjmQKb3tjX2TRv1hN//FkoA2h6WmFOQk=";
  };

  cargoHash = "sha256-DouQN9Lo/CoqZZD3HuO1+Xzvc2yL5l157TeAi+bmfrE=";

  meta = with lib; {
    description = "Save disk space by cleaning unneeded files from software projects";
    homepage = "https://github.com/tbillington/kondo";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
