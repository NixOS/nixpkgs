{
  buildGoModule,
  faketty,
  fetchFromGitHub,
  lib,
  nodejs,
  pnpm,
  stdenv,
}:
let
  version = "0.22.0";

  parca-src = fetchFromGitHub {
    owner = "parca-dev";
    repo = "parca";
    rev = "refs/tags/v${version}";
    hash = "sha256-iuTlKUmugRum0qZRhuw0FR13iE2qrQegTgwpAvgJSXk=";
  };

  ui = stdenv.mkDerivation (finalAttrs: {
    inherit version;
    pname = "parca-ui";
    src = "${parca-src}/ui";

    pnpmDeps = pnpm.fetchDeps {
      inherit (finalAttrs) pname src version;
      hash = "sha256-MVNO24Oksy/qRUmEUoWoviQEo6Eimb18ZnDj5Z1vJkY=";
    };

    nativeBuildInputs = [
      faketty
      nodejs
      pnpm.configHook
    ];

    # faketty is required to work around a bug in nx.
    # See: https://github.com/nrwl/nx/issues/22445
    buildPhase = ''
      runHook preBuild
      faketty pnpm build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/parca
      mv packages/app/web/build $out/share/parca/ui
      runHook postInstall
    '';
  });
in

buildGoModule rec {
  inherit version;

  pname = "parca";
  src = parca-src;

  vendorHash = "sha256-fErrbi3iSJlkguqzL6nH+fzmjxhoYVl1qH7tqRR1F1A=";

  ldflags = [
    "-X=main.version=${version}"
    "-X=main.commit=${src.rev}"
  ];

  preBuild = ''
    # Copy the built UI into the right place for the Go build to embed it.
    cp -r ${ui}/share/parca/ui/* ui/packages/app/web/build
  '';

  meta = {
    mainProgram = "parca";
    description = "Continuous profiling for analysis of CPU and memory usage";
    homepage = "https://github.com/parca-dev/parca";
    changelog = "https://github.com/parca-dev/parca/releases/tag/v${version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}
