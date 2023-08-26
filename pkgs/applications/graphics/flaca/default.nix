{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "flaca";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "Blobfolio";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-YLJ8jeJhpxmSfF0PObd7FSFdVbEVhHYIaUJusAIEIx4=";
  };

  # upstream does not provide a Cargo.lock
  cargoLock.lockFile = ./Cargo.lock;
  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  meta = with lib; {
    description = "A CLI tool to losslessly compress JPEG and PNG images";
    longDescription = "A CLI tool for x86-64 Linux machines that simplifies the task of maximally, losslessly compressing JPEG and PNG images for use in production web environments";
    homepage = "https://github.com/Blobfolio/flaca";
    maintainers = with maintainers; [ zzzsy ];
    platforms = platforms.linux;
    license = licenses.wtfpl;
  };
}
