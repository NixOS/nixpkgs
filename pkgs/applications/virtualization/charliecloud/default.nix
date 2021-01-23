{ lib, stdenv, fetchFromGitHub, python3, python3Packages, docker, autoreconfHook, coreutils, makeWrapper, gnused, gnutar, gzip, findutils, sudo, nixosTests }:

stdenv.mkDerivation rec {

  version = "0.21";
  pname = "charliecloud";

  src = fetchFromGitHub {
    owner = "hpc";
    repo = "charliecloud";
    rev = "v${version}";
    sha256 = "Y/tH6Znq//HBA/FHfIm2Wpppx6TiL7CqKtZFDc/XSNc=";
  };

  nativeBuildInputs = [ autoreconfHook makeWrapper ];
  buildInputs = [
    docker
    (python3.withPackages (ps: [ ps.lark-parser ps.requests ]))
  ];

  configureFlags = let
    pythonEnv = python3.withPackages (ps: [ ps.lark-parser ps.requests ]);
  in [
    "--with-python=${pythonEnv}/bin/python3"
  ];

  preConfigure = ''
    patchShebangs test/
    substituteInPlace configure.ac --replace "/usr/bin/env" "${coreutils}/bin/env"
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "LIBEXEC_DIR=lib/charliecloud"
  ];

  # Charliecloud calls some external system tools.
  # Here we wrap those deps so they are resolved inside nixpkgs.
  postInstall = ''
    for file in $out/bin/* ; do \
      wrapProgram $file --prefix PATH : ${lib.makeBinPath [ coreutils docker gnused gnutar gzip findutils sudo ]}
    done
  '';

  passthru.tests.charliecloud = nixosTests.charliecloud;

  meta = {
    description = "User-defined software stacks (UDSS) for high-performance computing (HPC) centers";
    longDescription = ''
      Charliecloud uses Linux user namespaces to run containers with no
      privileged operations or daemons and minimal configuration changes on
      center resources. This simple approach avoids most security risks
      while maintaining access to the performance and functionality already
      on offer.
    '';
    homepage = "https://hpc.github.io/charliecloud";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.bzizou ];
    platforms = lib.platforms.linux;
  };

}
