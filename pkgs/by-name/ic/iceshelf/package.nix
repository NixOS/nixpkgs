{
  lib,
  fetchFromGitHub,
  gnupg,
  gnutar,
  lbzip2,
  openssh,
  par2cmdline,
  python3Packages,
  unstableGitUpdater,
}:

python3Packages.buildPythonApplication {
  pname = "iceshelf";
  version = "0-unstable-2026-09-17";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "mrworf";
    repo = "iceshelf";
    rev = "a99b802ea1998da2d1b667004314eef787ff419c";
    hash = "sha256-GsJyFzM4k+S3jSR8/ncYto4mhRtatCU9jtRDNYesBUE=";
  };

  dependencies = with python3Packages; [
    boto3
    paramiko
    pyyaml
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      gnupg
      gnutar
      lbzip2
      openssh
      par2cmdline
    ])
  ];

  installPhase = ''
    mkdir -p $out/bin $out/share/doc/iceshelf $out/${python3Packages.python.sitePackages}
    cp -v iceshelf iceshelf-restore iceshelf-retrieve iceshelf-inspect $out/bin
    cp -v iceshelf.sample.conf $out/share/doc/iceshelf/
    cp -rv modules $out/${python3Packages.python.sitePackages}
  '';

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "Simple tool to allow storage of signed, encrypted, incremental backups using Amazon's Glacier storage";
    license = lib.licenses.gpl2Plus;
    homepage = "https://github.com/mrworf/iceshelf";
    maintainers = with lib.maintainers; [ mmahut ];
    mainProgram = "iceshelf";
  };
}
