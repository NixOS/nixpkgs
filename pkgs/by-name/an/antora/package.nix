{
  buildNpmPackage,
  callPackage,
  fetchFromGitLab,
  lib,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "antora";
  version = "3.1.14";

  src = fetchFromGitLab {
    owner = "antora";
    repo = "antora";
    tag = "v${version}";
    hash = "sha256-9x80aBm2ZBj389kX2wioe7BtaNjR7p9aEZg7o49v0vY=";
  };

  npmDepsHash = "sha256-s/f6/PxvSIlhFsCbsD25MPrk67vKXrnDqbfbW72Tr4I=";

  # This is to stop tests from being ran, as some of them fail due to trying to query remote repositories
  # Also disable the postbuild lint step which tries to download @biomejs/biome at build time
  postPatch = ''
    substituteInPlace package.json --replace-warn \
      '"_mocha"' '""'
    substituteInPlace package.json --replace-warn \
      '"npm run lint"' '""'
  '';

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/lib/node_modules/antora-build/packages/cli/bin/antora $out/bin/antora
  '';

  passthru = {
    tests.run = callPackage ./test { };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Modular documentation site generator. Designed for users of Asciidoctor";
    homepage = "https://antora.org";
    license = lib.licenses.mpl20;
    mainProgram = "antora";

    maintainers = with lib.maintainers; [
      ehllie
      naho
    ];

    platforms = lib.platforms.all;
  };
}
