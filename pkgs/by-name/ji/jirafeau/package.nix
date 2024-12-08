{ lib, stdenv, fetchFromGitLab, writeText, nixosTests }:
let
  localConfig = writeText "config.local.php" ''
    <?php
      return require(getenv('JIRAFEAU_CONFIG'));
    ?>
  '';
in
stdenv.mkDerivation rec {
  pname = "jirafeau";
  version = "4.4.0";

  src = fetchFromGitLab {
    owner = "mojo42";
    repo = "Jirafeau";
    rev = version;
    hash = "sha256-jJ2r8XTtAzawTVo2A2pDwy7Z6KHeyBkgXXaCPY0w/rg=";
  };

  installPhase = ''
    mkdir $out
    cp -r * $out/
    cp ${localConfig} $out/lib/config.local.php
  '';

  passthru.tests = { inherit (nixosTests) jirafeau; };

  meta = with lib; {
    description = "Website permitting upload of a file in a simple way and giving a unique link to it";
    license = licenses.agpl3Plus;
    homepage = "https://gitlab.com/mojo42/Jirafeau";
    platforms = platforms.all;
    maintainers = with maintainers; [ davidtwco ];
  };
}
