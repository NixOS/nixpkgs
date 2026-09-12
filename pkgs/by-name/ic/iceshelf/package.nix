{
  lib,
  fetchFromGitHub,
  git,
  awscli,
  python3Packages,
  unstableGitUpdater,
}:

python3Packages.buildPythonApplication {
  pname = "iceshelf";
  version = "0-unstable-2026-04-21";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "mrworf";
    repo = "iceshelf";
    rev = "21bb140efc9b493b8f329315ca114d31b760ee47";
    sha256 = "vVTUeW3L0NR+FCZP83wSg2xEUapBAYWD8fLmFwttjL4=";
  };

  propagatedBuildInputs = [
    awscli
    git
  ];

  dependencies = with python3Packages; [
    python-gnupg
  ];

  installPhase = ''
    mkdir -p $out/bin $out/share/doc/iceshelf $out/${python3Packages.python.sitePackages}
    cp -v iceshelf iceshelf-restore $out/bin
    cp -v iceshelf.sample.conf $out/share/doc/iceshelf/
    cp -rv modules $out/${python3Packages.python.sitePackages}
  '';

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "Simple tool to allow storage of signed, encrypted, incremental backups using Amazon's Glacier storage";
    license = lib.licenses.lgpl2;
    homepage = "https://github.com/mrworf/iceshelf";
    maintainers = with lib.maintainers; [ mmahut ];
    mainProgram = "iceshelf";
  };
}
