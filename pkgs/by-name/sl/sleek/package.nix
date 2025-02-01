{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "sleek";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "nrempel";
    repo = "sleek";
    rev = "v${version}";
    hash = "sha256-VQ0LmKhFsC12qoXCFHxtV5E+J7eRvZMVH0j+5r8pDk8=";
  };

  # 0.3.0 has been tagged before the actual Cargo.lock bump, resulting in an inconsitent lock file.
  # To work around this, the Cargo.lock below is from the commit right after the tag:
  # https://github.com/nrempel/sleek/commit/18c5457a813a16e3eebfc1c6f512131e6e8daa02
  postPatch = ''
    ln -s --force ${./Cargo.lock} Cargo.lock
  '';

  cargoLock.lockFile = ./Cargo.lock;

  meta = with lib; {
    description = "CLI tool for formatting SQL";
    homepage = "https://github.com/nrempel/sleek";
    license = licenses.mit;
    maintainers = with maintainers; [ xrelkd ];
    mainProgram = "sleek";
  };
}
