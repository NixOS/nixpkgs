{
  buildNpmPackage,
  callPackage,
  fetchFromGitLab,
  lib,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "antora";
  version = "3.1.15";

  src = fetchFromGitLab {
    owner = "antora";
    repo = "antora";
    tag = "v${version}";
    hash = "sha256-Ok9KuDiyKEY8ggo1TnlME91zj4zvv4CWR1hldDheVgs=";
  };

  npmDepsHash = "sha256-AuYEi2T+yLtJyJIJIzTol+cs+9Terqe3bQalVnq2XR4=";

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
      noahbiewesch
    ];

    platforms = lib.platforms.all;
  };
}
