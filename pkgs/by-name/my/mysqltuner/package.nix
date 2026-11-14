{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mysqltuner";
  version = "2.9.3";

  src = fetchFromGitHub {
    owner = "major";
    repo = "MySQLTuner-perl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bg8RusoGbwGIjZz5T9YmyjQ3xiWjwicmZb6sJMttgK8=";
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

  meta = {
    description = "Make recommendations for increased performance and stability of MariaDB/MySQL";
    homepage = "https://github.com/major/MySQLTuner-perl";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      peterhoeg
    ];
    mainProgram = "mysqltuner";
  };
})
