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
  version = "0.24.2";

  parca-src = fetchFromGitHub {
    owner = "parca-dev";
    repo = "parca";
    tag = "v${version}";
    hash = "sha256-gzQIgpouCsoMkQtjWubH7IGLiTUS6oX7oAboU8IuEOs=";
  };

  ui = stdenv.mkDerivation (finalAttrs: {
    inherit version;
    pname = "parca-ui";
    src = "${parca-src}/ui";

    pnpmDeps = pnpm_9.fetchDeps {
      inherit (finalAttrs) pname src version;
      fetcherVersion = 1;
      hash = "sha256-5cn3fAvOXCQyiqlA0trIi/hCIfgB6xNO1pc5ZMBfouc=";
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

  vendorHash = "sha256-uQuurwrrhs+JM72/Nd4xOLampIKwwpOehQ7dqMZi3v0=";

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
