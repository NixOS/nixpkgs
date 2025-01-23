{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
}:
stdenv.mkDerivation rec {
  pname = "mysqltuner";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "major";
    repo = "MySQLTuner-perl";
    rev = "v${version}";
    hash = "sha256-JIO/auY8E6at9OCIqgKbBz9OhOeZMtQvUoUYPMEVtCg=";
  };

  postPatch = ''
    substituteInPlace mysqltuner.pl \
      --replace-fail '/usr/share' "$out/share"
  '';

  buildInputs = [ perl ];
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm0555 mysqltuner.pl $out/bin/mysqltuner
    install -Dm0444 -t $out/share/mysqltuner basic_passwords.txt vulnerabilities.csv

    runHook postInstall
  '';

  meta = with lib; {
    description = "Make recommendations for increased performance and stability of MariaDB/MySQL";
    homepage = "https://github.com/major/MySQLTuner-perl";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      peterhoeg
      shamilton
    ];
    mainProgram = "mysqltuner";
  };
}
