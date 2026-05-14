{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPackages,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eigenmath";
  version = "350";

  src = fetchFromGitHub {
    owner = "georgeweigt";
    repo = "eigenmath";
    tag = finalAttrs.version;
    hash = "sha256-Depc6mzPK6FEGTUo2BmXoWlyzjQDU8Hiodp5UjxKlQE=";
  };

  checkPhase =
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      runHook preCheck
      echo -e "clear\nstatus\nexit" >> test/selftest
      ${emulator} ./eigenmath "test/selftest"
      runHook postCheck
    '';

  # https://github.com/georgeweigt/eigenmath/issues/32
  env.NIX_CFLAGS_COMPILE = "-std=gnu17";

  installPhase = ''
    runHook preInstall
    install -Dm555 eigenmath "$out/bin/eigenmath"
    runHook postInstall
  '';

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Computer algebra system written in C";
    mainProgram = "eigenmath";
    homepage = "https://georgeweigt.github.io";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nickcao ];
    platforms = lib.platforms.unix;
  };
})
