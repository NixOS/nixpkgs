{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "taskwarrior-tui";
  version = "0.9.15";

  src = fetchFromGitHub {
    owner = "kdheepak";
    repo = "taskwarrior-tui";
    rev = "v${version}";
    sha256 = "0jcqla93f4akmf05afdppv5cma346ci6nmwn4wkyxi53jx49x4n7";
  };

  # Because there's a test that requires terminal access
  doCheck = false;

  cargoSha256 = "1izzb0x1m0yni7861p99zs5ayxy9r72ad1mbrji42gqw3vx8c75p";

  meta = with lib; {
    description = "A terminal user interface for taskwarrior ";
    homepage = "https://github.com/kdheepak/taskwarrior-tui";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
