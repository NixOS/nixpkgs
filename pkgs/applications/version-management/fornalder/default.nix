{ fetchFromGitHub, rustPlatform, lib }:

rustPlatform.buildRustPackage rec {
  pname = "fornalder";
  version = "unstable-2022-07-23";

  src = fetchFromGitHub {
    owner = "hpjansson";
    repo = pname;
    rev = "44129f01910a9f16d97d0a3d8b1b376bf3338ea6";
    sha256 = "sha256-YODgR98SnpL6SM2nKrnzhpsEzYQFqduqigua/SXhazk=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  # tests don't typecheck
  doCheck = false;

  meta = with lib; {
    description = "Visualize long-term trends in collections of Git repositories";
    homepage = "https://github.com/hpjansson/fornalder";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ astro ];
  };
}
