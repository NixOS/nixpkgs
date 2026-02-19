{
  lib,
  stdenv,
  catch2_3,
  fetchFromGitHub,
  cmake,
  boehmgc,
  boost,
  fmt,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "immer";

  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "arximboldi";
    repo = "immer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Qrr5mDbPF9cbLi9T2IVAKPN3CkTxffoivvqGNGLdkxE=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ (lib.cmakeBool "immer_BUILD_TESTS" finalAttrs.finalPackage.doCheck) ];

  # immer is a header only library
  dontBuild = true;
  buildInputs = [ ];
  dontUseCmakeBuildDir = true;

  doCheck = false;

  strictDeps = true;

  passthru = {
    tests.test = finalAttrs.finalPackage.overrideAttrs (attrs: {
      pname = "${attrs.pname}-test";
      doCheck = true;
      checkInputs = [
        catch2_3
        boehmgc
        boost
        fmt
      ];
      checkPhase = ''
        make check
      '';
    });
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Postmodern immutable and persistent data structures for C++ — value semantics at scale";
    homepage = "https://sinusoid.es/immer";
    changelog = "https://github.com/arximboldi/immer/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ sifmelcara ];
    platforms = lib.platforms.all;
  };
})
