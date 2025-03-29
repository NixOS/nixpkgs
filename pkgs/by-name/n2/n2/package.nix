{
  lib,
  rustPlatform,
  fetchFromGitHub,
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

  useFetchCargoVendor = true;
  cargoHash = "sha256-bVvtTsaLnsmfzv2wMFx81a2ef91pj8XGtXhj8X9WFlc=";

  meta = with lib; {
    homepage = "https://github.com/evmar/n2";
    description = "Ninja compatible build system";
    mainProgram = "n2";
    license = licenses.asl20;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}
