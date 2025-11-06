{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "pdfrip";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "mufeedvh";
    repo = "pdfrip";
    tag = "v${version}";
    hash = "sha256-9KDWd71MJ2W9Xp3uqp0iZMmkBwIay+L4gnPUt7hylS0=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  meta = {
    description = "PDF password cracking utility";
    homepage = "https://github.com/mufeedvh/pdfrip";
    changelog = "https://github.com/mufeedvh/pdfrip/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pdfrip";
  };
}
