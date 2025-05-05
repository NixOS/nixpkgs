{
  buildGoModule,
  faketty,
  fetchFromGitHub,
  lib,
  nodejs,
  pnpm_9,
  stdenv,
}:
let
  version = "0.23.1";

  parca-src = fetchFromGitHub {
    owner = "parca-dev";
    repo = "parca";
    tag = "v${version}";
    hash = "sha256-UCYBT+KegoXpMRMoA3iuX8WiXhkX43JVOmhHksH5Pwk=";
  };

  ui = stdenv.mkDerivation (finalAttrs: {
    inherit version;
    pname = "parca-ui";
    src = "${parca-src}/ui";

    pnpmDeps = pnpm_9.fetchDeps {
      inherit (finalAttrs) pname src version;
      hash = "sha256-MByoIJtynv38TFNVDdZWjkJJpABCjJU2wBrChxM2rdE=";
    };

    nativeBuildInputs = [
      faketty
      nodejs
      pnpm_9.configHook
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

  vendorHash = "sha256-O7dzdMGZ1l+cmVA3svbh/Ig1SbXXiMwJ7TXmrT2IM+g=";

  ldflags = [
    "-X=main.version=${version}"
    "-X=main.commit=${src.rev}"
  ];

  preBuild = ''
    # Copy the built UI into the right place for the Go build to embed it.
    cp -r ${ui}/share/parca/ui/* ui/packages/app/web/build
  '';

  passthru = {
    inherit ui;
    updateScript = ./update.sh;
  };

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
