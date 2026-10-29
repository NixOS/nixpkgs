{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
  nixosTests,
  nodejs,
}:

buildNpmPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "kener";
  version = "4.1.7";

  src = fetchFromGitHub {
    owner = "rajnandan1";
    repo = "kener";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/S7foXt5MjyO8NMlUul2SxF1VaVUUjTV5dRJKOE2bUI=";
  };

  npmDepsHash = "sha256-frv6Opzvh7LXCz0aslKh03zpeztRcsM0lkrVd1a0JvI=";
  postFixup = ''
    makeWrapper ${nodejs}/bin/node $out/bin/kener-server \
      --add-flags $out/lib/node_modules/kener/build/main.js \
      --chdir $out/lib/node_modules/kener
  '';
  postInstall = ''
    # The build dir is not picked up by `npm pack`. Let’s copy it manually.
    cp -r build $out/lib/node_modules/kener/
    # This is needed because kener relies on type stripping for db migration and seeding.
    # But type stripping cannot occur if the caconical path contains `node_modules` anywhere, which
    # the default installed path contains. So we move the built artifacts from the standard path to
    # another, and add a symlink back, to not break anything.
    mv $out/lib/node_modules/kener $out/lib
    ln -s $out/lib/kener $out/lib/node_modules/kener
  '';

  passthru.tests.kener = nixosTests.kener;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern, open-source status page application built with Node.js";
    homepage = "https://kener.ing";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ albertlarsan68 ];
    mainProgram = "kener-server";
  };
})
