{
  callPackage,
  stdenv,
  fetchFromGitHub,
  lib,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "microhs";
  version = "0.15.3.0";

  src = fetchFromGitHub {
    owner = "augustss";
    repo = "MicroHs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JuqdArVzziJC4/QZLfPguXbd+ZiPD3bgf1mGYghkxy0=";
  };

  # mcabal doesn't seem to respect the make flag and fails with /homeless-shelter
  # This works around the issue
  nativeBuildInputs = [ writableTmpDirAsHomeHook ];

  makeFlags = [ "MCABAL=$(out)" ];
  buildFlags = [ "bootstrap" ];

  # MicroCabal is a separate repository, which should be packaged separately
  # The MicroCabal that is installed by `make install` is pregenerated, does not respect MCABAL above, and so is not useable
  postInstall = "rm $out/bin/mcabal";

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      hello-world = callPackage ./test-hello-world.nix { microhs = finalAttrs.finalPackage; };
    };
  };

  meta = {
    description = "Haskell implemented with combinators";
    homepage = "https://github.com/augustss/MicroHs";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.steeleduncan ];
    platforms = lib.platforms.all;
  };
})
