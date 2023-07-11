{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, perl
, Security ? null
}:

rustPlatform.buildRustPackage rec {
  pname = "kubectl-view-allocations";
  version = "0.16.3";

  src = fetchFromGitHub {
    owner = "davidB";
    repo = pname;
    rev = version;
    sha256 = "sha256-udi39j/K4Wsxva171i7mMUQ6Jb8Ny2IEHfldt3B8IoY=";
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [ perl ];
  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "kubectl plugin to list allocations (cpu, memory, gpu,... X utilization, requested, limit, allocatable,...)";
    homepage = "https://github.com/davidB/kubectl-view-allocations";
    license = licenses.cc0;
    maintainers = [ maintainers.mrene ];
    platforms = platforms.unix;
  };
}
