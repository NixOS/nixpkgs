{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, Security ? null
}:

rustPlatform.buildRustPackage rec {
  pname = "kubectl-view-allocations";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "davidB";
    repo = pname;
    rev = version;
    sha256 = "sha256-BM0TLzoXQg3m5fdQEnO/tErW8xmuljo74GprwEgJN8o=";
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "kubectl plugin to list allocations (cpu, memory, gpu,... X utilization, requested, limit, allocatable,...)";
    homepage = "https://github.com/davidB/kubectl-view-allocations";
    license = licenses.cc0;
    maintainers = [ maintainers.mrene ];
    platforms = platforms.unix;
  };
}
