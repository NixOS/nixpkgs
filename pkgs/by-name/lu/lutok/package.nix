{
  lib,
  stdenv,
  fetchFromGitHub,
  atf,
  autoreconfHook,
  kyua,
  lua5_5,
  pkg-config,
  gitUpdater,
}:

let
  lua = lua5_5;
in

lib.fix (
  drv:
  let
    # Avoid infinite recursions:
    # - Lutok depends on ATF and Kyua for testing; but
    # - ATF depends on Kyua for testing, and Kyua depends on Lutok as a build input.
    # To break the cycle (ATF -> Kyua -> Lutok -> ATF and Kyua):
    # - Build ATF without testing (avoiding the Kyua dependency); and
    # - Build Kyua against a version of Lutok without testing (also avoiding the ATF and Kyua dependencies).
    atf' = atf.overrideAttrs (_: {
      doInstallCheck = false;
    });
    kyua' =
      (kyua.override {
        lutok = drv.overrideAttrs (_: {
          doInstallCheck = false;
        });
      }).overrideAttrs
        (_: {
          # Assume Kyua’s install check phase will run when Kyua is built. Don’t run it again
          # while building Lutok because it can take four to five minutes to run.
          doInstallCheck = false;
        });
  in
  stdenv.mkDerivation (finalAttrs: {
    pname = "lutok";
    version = "0.6.3";

    outputs = [
      "out"
      "dev"
    ];

    src = fetchFromGitHub {
      owner = "freebsd";
      repo = "lutok";
      rev = "lutok-${finalAttrs.version}";
      hash = "sha256-HpTs/BF0F3jFZrh6K5X6z6T9ySK/EsR/KZw1462RDTY=";
    };

    strictDeps = true;

    propagatedBuildInputs = [ lua ];

    nativeBuildInputs = [
      atf'
      autoreconfHook
      pkg-config
    ];

    configureFlags = lib.optionals finalAttrs.finalPackage.doInstallCheck [
      (lib.enableFeature true "atf")
    ];

    enableParallelBuilding = true;

    doInstallCheck = true;

    installCheckInputs = [ atf' ];
    nativeInstallCheckInputs = [ kyua' ];

    # Lutok expects to run the installed tests. Run them as part of check phase then delete them to avoid creating
    # references to the ATF package used to bootstrap Lutok.
    installCheckPhase = ''
      runHook preInstallCheck
      cd $out/tests/lutok
      HOME=$TMPDIR PATH+=$out/bin:$PATH PKG_CONFIG_PATH=''${!outputDev}/lib/pkgconfig:$PKG_CONFIG_PATH kyua test
      rm -rf $out/tests/lutok
      runHook postInstallCheck
    '';

    passthru.updateScript = gitUpdater { rev-prefix = "lutok-"; };

    __structuredAttrs = true;

    meta = {
      description = "Lightweight C++ API for Lua";
      homepage = "https://github.com/freebsd/lutok/";
      license = lib.licenses.bsd3;
      maintainers = with lib.maintainers; [ reckenrode ];
      platforms = lib.platforms.unix;
    };
  })
)
