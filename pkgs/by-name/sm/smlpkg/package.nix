{
  lib,
  stdenv,
  fetchFromGitHub,
  mlton,
  unzip,
}:

stdenv.mkDerivation rec {
  pname = "smlpkg";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "diku-dk";
    repo = "smlpkg";
    rev = "v${version}";
    sha256 = "1xmbdnfc34ia0a78dhkfv5jyadxndinhw8c47l1mjd4l7n8vqnph";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ mlton ];

  # Set as an environment variable in all the phase scripts.
  MLCOMP = "mlton";

  buildFlags = [ "all" ];
  installFlags = [ "prefix=$(out)" ];

  doCheck = true;

  nativeCheckInputs = [ unzip ];

  # We cannot run the pkgtests, as Nix does not allow network
  # connections.
  checkPhase = ''
    runHook preCheck
    make -C src test
    runHook postCheck
  '';

  meta = with lib; {
    description = "Generic package manager for Standard ML libraries and programs";
    homepage = "https://github.com/diku-dk/smlpkg";
    license = licenses.mit;
    platforms = mlton.meta.platforms;
    maintainers = with maintainers; [ athas ];
    mainProgram = "smlpkg";
  };
}
