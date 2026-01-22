{
  callPackage,
  stdenv,
  fetchFromGitHub,
  lib,
  writableTmpDirAsHomeHook,
  writeTextDir,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "microhs";
  version = "0.14.21.0";

  src = fetchFromGitHub {
    owner = "augustss";
    repo = "MicroHs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Tq8fjI3LCP4NWrmbMP0xyhY2fjRmsMCEvgfDQ/SB5Bo=";
  };

  # mcabal doesn't seem to respect the make flag and fails with /homeless-shelter
  # This works around the issue
  nativeBuildInputs = [ writableTmpDirAsHomeHook ];

  makeFlags = [ "MCABAL=$(out)" ];
  buildFlags = [ "bootstrap" ];

  # MicroCabal is a separate repository, which should be packaged separately
  # The MicroCabal that is installed by `make install` is pregenerated, does not respect MCABAL above, and so is not useable
  postInstall = "rm $out/bin/mcabal";

  passthru.tests = {
    hello-world = callPackage ./test-hello-world.nix { microhs = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Haskell implemented with combinators";
    homepage = "https://github.com/augustss/MicroHs";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.steeleduncan ];
    platforms = lib.platforms.all;
  };
})
