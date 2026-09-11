{
  lib,
  stdenv, # for tests
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "jsmn";
  version = "1.1.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "zserge";
    repo = "jsmn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Vv8Cqb+WZZVnmtVZ12JYd5/qUrqLqi4lvNsUyj9NnRQ=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 jsmn.h $out/include/jsmn.h

    runHook postInstall
  '';

  passthru.tests.suite = stdenv.mkDerivation {
    pname = "jsmn-tests";

    inherit (finalAttrs) version src;

    dontConfigure = true;
    dontBuild = true;

    doCheck = true;
    checkPhase = ''
      runHook preCheck

      make test

      runHook postCheck
    '';

    installPhase = ''
      runHook preInstall

      touch $out

      runHook postInstall
    '';
  };

  meta = {
    description = "Minimalistic JSON parser in C";
    maintainers = with lib.maintainers; [ BatteredBunny ];
    homepage = "https://github.com/zserge/jsmn";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
