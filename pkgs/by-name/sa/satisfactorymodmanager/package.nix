{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nodejs,
  pnpm_8,
  wails,
  wrapGAppsHook3,
}:

buildGoModule rec {
  pname = "satisfactorymodmanager";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "satisfactorymodding";
    repo = "SatisfactoryModManager";
    tag = "v${version}";
    hash = "sha256-ndvrgSRblm7pVwnGvxpwtGVMEGp+mqpC4kE87lmt36M=";
  };

  patches = [
    # disable postcss-import-url
    ./dont-vendor-remote-fonts.patch
  ];

  postPatch = ''
    # don't generate i18n and graphql code
    substituteInPlace frontend/package.json \
        --replace-fail '"postinstall":' '"_postinstall":'

    rm -r frontend/src/lib/generated/graphql
    cp -r --no-preserve=all ${./generated/i18n} frontend/src/lib/generated/i18n
    cp -r --no-preserve=all ${./generated/graphql} frontend/src/lib/generated/graphql
  '';

  nativeBuildInputs = [
    nodejs
    pnpm_8.configHook
    wails
    wrapGAppsHook3
  ];

  # we use env because buildGoModule doesn't forward all normal attrs
  # this is pretty hacky
  env = {
    pnpmDeps = pnpm_8.fetchDeps {
      inherit pname version src;
      sourceRoot = "${src.name}/frontend";
      hash = "sha256-OP+3zsNlvqLFwvm2cnBd2bj2Kc3EghQZE3hpotoqqrQ=";
    };

    pnpmRoot = "frontend";
  };

  # running this caches some additional dependencies for the FOD
  overrideModAttrs = {
    preBuild = ''
      wails build
    '';
  };

  proxyVendor = true;

  vendorHash = "sha256-3nsJPuwL2Zw/yuHvd8rMSpj9DBBpYUaR19z9TSV/7jg=";

  buildPhase = ''
    runHook preBuild
    wails build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 build/bin/SatisfactoryModManager -t "$out/bin"
    runHook postInstall
  '';

  meta = {
    description = "Mod manager and modloader for Satisfactory";
    homepage = "https://github.com/satisfactorymodding/SatisfactoryModManager";
    license = with lib.licenses; [
      gpl3Only
      asl20 # Roboto font
      ofl # other fonts
    ];
    mainProgram = "SatisfactoryModManager";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
