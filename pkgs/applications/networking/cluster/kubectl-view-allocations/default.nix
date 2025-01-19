{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  Security ? null,
}:

rustPlatform.buildRustPackage rec {
  pname = "kubectl-view-allocations";
  version = "0.20.3";

  src = fetchFromGitHub {
    owner = "davidB";
    repo = pname;
    rev = version;
    sha256 = "sha256-JnxnEvew9J38hK4MqOjsCDZ2SJa9NknAJkhxFruCKmo=";
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/kubectl-view-allocations --help
    $out/bin/kubectl-view-allocations --version | grep -e "kubectl-view-allocations ${version}"
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "kubectl plugin to list allocations (cpu, memory, gpu,... X utilization, requested, limit, allocatable,...)";
    homepage = "https://github.com/davidB/kubectl-view-allocations";
    license = licenses.cc0;
    maintainers = [ maintainers.mrene ];
    platforms = platforms.unix;
  };
}
