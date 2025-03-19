{
  lib,
  stdenv,
  fetchFromGitHub,
  atf,
  autoreconfHook,
  kyua,
  lua,
  pkg-config,
  gitUpdater,
}:

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
          doCheck = false;
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
    version = "0.4";

    outputs = [
      "out"
      "dev"
    ];

    src = fetchFromGitHub {
      owner = "freebsd";
      repo = "lutok";
      rev = "lutok-${finalAttrs.version}";
      hash = "sha256-awAFxx9q8dZ6JO1/mShjhJnOPTLn1wCT4VrB4rlgWyg=";
    };

    strictDeps = true;

    propagatedBuildInputs = [ lua ];

    nativeBuildInputs = [
      atf'
      autoreconfHook
      pkg-config
    ];

    enableParallelBuilding = true;

    makeFlags = [
      # Lutok isn’t compatible with C++17, which is the default on current clang and GCC.
      "CXXFLAGS=-std=c++11"
    ];

    doCheck = true;

    checkInputs = [ atf' ];
    nativeCheckInputs = [ kyua' ];

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
