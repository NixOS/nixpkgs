{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
}:
{
  bats-assert = stdenv.mkDerivation (finalAttrs: {
    pname = "bats-assert";
    version = "2.2.4";
    src = fetchFromGitHub {
      owner = "bats-core";
      repo = "bats-assert";
      rev = "v${finalAttrs.version}";
      hash = "sha256-TmLCSYT9JyC09XxyfTa7Ls2aEFuwDkCiddwZxkg/8vc=";
    };
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir -p "$out/share/bats/bats-assert"
      cp load.bash "$out/share/bats/bats-assert"
      cp -r src "$out/share/bats/bats-assert"
      runHook postInstall
    '';
    meta = {
      description = "Common assertions for Bats";
      platforms = lib.platforms.all;
      homepage = "https://github.com/bats-core/bats-assert";
      license = lib.licenses.cc0;
      maintainers = with lib.maintainers; [ brokenpip3 ];
    };
  });

  bats-file = stdenv.mkDerivation (finalAttrs: {
    pname = "bats-file";
    version = "0.4.0";
    src = fetchFromGitHub {
      owner = "bats-core";
      repo = "bats-file";
      rev = "v${finalAttrs.version}";
      hash = "sha256-NJzpu1fGAw8zxRKFU2awiFM2Z3Va5WONAD2Nusgrf4o=";
    };
    patches = [
      # unreleased fix for test broken on macOS:
      # not ok 149 temp_make() <var>: returns 1 and displays an error message if the directory can not be created
      (fetchpatch {
        url = "https://github.com/bats-core/bats-file/commit/7d839ca2a08db33e1014ae98d301c0e492f4f340.patch";
        hash = "sha256-MLPWTrfrBvveE7EVp6jw2MVwNc0JxJuWpOuPrlPIgj8=";
      })
    ];
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir -p "$out/share/bats/bats-file"
      cp load.bash "$out/share/bats/bats-file"
      cp -r src "$out/share/bats/bats-file"
      runHook postInstall
    '';
    passthru.testPatch = ''
      echo removing block/character special-device tests test/54-55
      rm test/54* test/55*

      echo removing ownership-changing tests test/59
      rm test/59*

      echo removing setuid/gid tests test/62* test/63*
      rm test/62* test/63*

    ''
    + (lib.optionalString stdenv.hostPlatform.isDarwin ''
      echo "removing stat-invoking tests that try to force BSD flags on macOS:" test/60*
      echo can remove when https://github.com/bats-core/bats-file/issues/111 is fixed
      rm test/60*
    '');
    meta = {
      description = "Common filesystem assertions for Bats";
      platforms = lib.platforms.all;
      homepage = "https://github.com/bats-core/bats-file";
      license = lib.licenses.cc0;
      maintainers = with lib.maintainers; [ brokenpip3 ];
    };
  });

  bats-detik = stdenv.mkDerivation (finalAttrs: {
    pname = "bats-detik";
    version = "1.4.0";
    src = fetchFromGitHub {
      owner = "bats-core";
      repo = "bats-detik";
      rev = "v${finalAttrs.version}";
      hash = "sha256-vFR7i14adkbtTpJCx6WVzdboINHHoEEUODEZTOh840k=";
    };
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir -p "$out/share/bats/bats-detik"
      cp -r lib/* "$out/share/bats/bats-detik"
      runHook postInstall
    '';
    meta = {
      description = "Library to ease e2e tests of applications in K8s environments";
      platforms = lib.platforms.all;
      homepage = "https://github.com/bats-core/bats-detik";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ brokenpip3 ];
    };
  });

  bats-support = stdenv.mkDerivation (finalAttrs: {
    pname = "bats-support";
    version = "0.3.0";
    src = fetchFromGitHub {
      owner = "bats-core";
      repo = "bats-support";
      rev = "v${finalAttrs.version}";
      hash = "sha256-4N7XJS5XOKxMCXNC7ef9halhRpg79kUqDuRnKcrxoeo=";
    };
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir -p "$out/share/bats/bats-support"
      cp load.bash "$out/share/bats/bats-support"
      cp -r src "$out/share/bats/bats-support"
      runHook postInstall
    '';
    meta = {
      description = "Supporting library for Bats test helpers";
      platforms = lib.platforms.all;
      homepage = "https://github.com/bats-core/bats-support";
      license = lib.licenses.cc0;
      maintainers = with lib.maintainers; [ brokenpip3 ];
    };
  });
}
