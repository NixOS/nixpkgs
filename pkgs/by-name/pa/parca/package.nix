{
  buildGoModule,
  faketty,
  fetchFromGitHub,
  lib,
  nodejs,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
  stdenv,
}:
let
  version = "0.28.0";

  parca-src = fetchFromGitHub {
    owner = "parca-dev";
    repo = "parca";
    tag = "v${version}";
    hash = "sha256-7ndRiOYa7HiOwwHRXqeCr3A+5EAVvbo4I4vkoqSya+E=";
  };

  ui = stdenv.mkDerivation (finalAttrs: {
    inherit version;
    pname = "parca-ui";
    src = "${parca-src}/ui";

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname src version;
      pnpm = pnpm_9;
      fetcherVersion = 3;
      hash = "sha256-zHdMwJyeafzbIlp+Fhh1khcUVrLsoUg6ViSGm/ByGAA=";
    };

    nativeBuildInputs = [
      faketty
      nodejs
      pnpmConfigHook
      pnpm_9
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

  vendorHash = "sha256-eZPAgxOi1jgTHmisFG/Sz2y3vhxUu/L3Iodb5mrKnVs=";

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
    maintainers = with lib.maintainers; [
      brancz
      metalmatze
    ];
  };
}
