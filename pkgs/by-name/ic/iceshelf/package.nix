{
  lib,
  fetchFromGitHub,
  git,
  awscli,
  python3,
}:

python3.pkgs.buildPythonApplication {
  pname = "iceshelf";
  version = "0-unstable-2019-07-03";

  format = "other";

  src = fetchFromGitHub {
    owner = "mrworf";
    repo = "iceshelf";
    rev = "26768dde3fc54fa412e523eb8f8552e866b4853b";
    sha256 = "08rcbd14vn7312rmk2hyvdzvhibri31c4r5lzdrwb1n1y9q761qm";
  };

  propagatedBuildInputs = [
    git
    awscli
    python3.pkgs.python-gnupg
  ];

  installPhase = ''
    mkdir -p $out/bin $out/share/doc/iceshelf $out/${python3.sitePackages}
    cp -v iceshelf iceshelf-restore $out/bin
    cp -v iceshelf.sample.conf $out/share/doc/iceshelf/
    cp -rv modules $out/${python3.sitePackages}
  '';

  meta = with lib; {
    description = "Simple tool to allow storage of signed, encrypted, incremental backups using Amazon's Glacier storage";
    license = licenses.lgpl2;
    homepage = "https://github.com/mrworf/iceshelf";
    maintainers = with maintainers; [ mmahut ];
  };
}
