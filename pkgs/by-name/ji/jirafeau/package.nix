{
  lib,
  stdenv,
  fetchFromGitLab,
  writeText,
  nixosTests,
}:
let
  localConfig = writeText "config.local.php" ''
    <?php
      return require(getenv('JIRAFEAU_CONFIG'));
    ?>
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "jirafeau";
  version = "4.4.0";

  src = fetchFromGitLab {
    owner = "mojo42";
    repo = "Jirafeau";
    rev = finalAttrs.version;
    hash = "sha256-jJ2r8XTtAzawTVo2A2pDwy7Z6KHeyBkgXXaCPY0w/rg=";
  };

  installPhase = ''
    mkdir $out
    cp -r * $out/
    cp ${localConfig} $out/lib/config.local.php
  '';

  passthru.tests = { inherit (nixosTests) jirafeau; };

  meta = {
    description = "Website permitting upload of a file in a simple way and giving a unique link to it";
    license = lib.licenses.agpl3Plus;
    homepage = "https://gitlab.com/mojo42/Jirafeau";
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})
