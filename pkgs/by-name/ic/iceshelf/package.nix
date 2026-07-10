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
  version = "0-unstable-2025-06-29";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "mrworf";
    repo = "iceshelf";
    rev = "5380c49e3f7f3df04b61a494b2d94db2f2c65e25";
    sha256 = "hiJZX6HG6a9kUr8R7DdkPBcuH3tmVJthWXrPtCaVayU=";
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
