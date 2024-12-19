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
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-lZpF7PdUwKnV0ha6xkLvi7XYFZQ4Avy0ltlXxukuWjM=";
  };

  buildInputs = [
    libaio
  ];

  meta = with lib; {
    description = "Userspace memory and IO stress test tool";
    homepage = "https://github.com/stressapptest/stressapptest";
    changelog = "https://github.com/stressapptest/stressapptest/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    platforms = platforms.unix;
    mainProgram = "stressapptest";
  };
}
