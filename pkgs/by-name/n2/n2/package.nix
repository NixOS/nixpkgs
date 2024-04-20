{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage {
  pname = "n2";
  version = "unstable-2023-10-10";

  src = fetchFromGitHub {
    owner = "evmar";
    repo = "n2";
    rev = "90041c1f010d27464e3b18e38440ed9855ea62ef";
    hash = "sha256-svJPcriSrqloJlr7pIp/k84O712l4ZEPlSr58GPANXY=";
  };

  cargoHash = "sha256-jrIo0N3o2fYe3NgNG33shkMd0rJxi5evtidCL9BcfVc=";

  meta = with lib; {
    homepage = "https://github.com/evmar/n2";
    description = "A ninja compatible build system";
    mainProgram = "n2";
    license = licenses.asl20;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}
