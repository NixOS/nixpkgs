{
  buildNpmPackage,
  callPackage,
  fetchFromGitLab,
  lib,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "antora";
  version = "3.1.9";

  src = fetchFromGitLab {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-hkavYC2LO8NRIRwHNWIJLRDkVnhAB4Di3IqL8uGt+U8=";
  };

  npmDepsHash = "sha256-ngreuitwUcIDVF6vW7fZA1OaVxr9fv7s0IjCErXlcxg=";

  # This is to stop tests from being ran, as some of them fail due to trying to query remote repositories
  postPatch = ''
    substituteInPlace package.json --replace \
      '"_mocha"' '""'
  '';

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/lib/node_modules/antora-build/packages/cli/bin/antora $out/bin/antora
  '';

  passthru = {
    tests.run = callPackage ./test { };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Modular documentation site generator. Designed for users of Asciidoctor";
    homepage = "https://antora.org";
    license = licenses.mpl20;
    mainProgram = "antora";

    maintainers = with maintainers; [
      ehllie
      naho
    ];

    platforms = lib.platforms.all;
  };
}
