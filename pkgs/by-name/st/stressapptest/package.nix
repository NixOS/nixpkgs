{
  lib,
  stdenv,
  fetchFromGitHub,
  libaio,
}:

stdenv.mkDerivation rec {
  pname = "stressapptest";
  version = "1.0.11";

  src = fetchFromGitHub {
    owner = "stressapptest";
    repo = "stressapptest";
    tag = "v${version}";
    hash = "sha256-lZpF7PdUwKnV0ha6xkLvi7XYFZQ4Avy0ltlXxukuWjM=";
  };

  buildInputs = [
    libaio
  ];

  meta = {
    description = "Userspace memory and IO stress test tool";
    homepage = "https://github.com/stressapptest/stressapptest";
    changelog = "https://github.com/stressapptest/stressapptest/releases/tag/v${version}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
    platforms = lib.platforms.unix;
    mainProgram = "stressapptest";
  };
}
