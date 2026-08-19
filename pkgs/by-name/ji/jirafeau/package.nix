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
  version = "4.7.2";

  src = fetchFromGitLab {
    owner = "jirafeau";
    repo = "Jirafeau";
    rev = finalAttrs.version;
    hash = "sha256-zCmSdlHkYQVQXBeVk8AUPoC0UBxz3hWIdM2tGmnLTrw=";
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
    homepage = "https://gitlab.com/jirafeau/Jirafeau";
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})
