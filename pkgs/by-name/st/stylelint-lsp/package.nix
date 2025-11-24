{
  fetchFromGitHub,
  lib,
  nodejs,
  pnpm_9,
  stdenvNoCC,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "stylelint-lsp";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "bmatcuk";
    repo = "stylelint-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LUX/H7yY8Dl44vgpf7vOgtMdY7h//m5BAfrK5RRH9DM=";
  };

  buildInputs = [
    nodejs
  ];

  nativeBuildInputs = [
    pnpm_9.configHook
  ];

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-PVA6sXbiuxqvi9u3sPoeVIJSSpSbFQHQQnTFO3w31WE=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  preInstall = ''
    # remove unnecessary files
    CI=true pnpm --ignore-scripts prune --prod
    rm -rf node_modules/.pnpm/typescript*
    find -type f \( -name "*.ts" -o -name "*.map" \) -exec rm -rf {} +
    # https://github.com/pnpm/pnpm/issues/3645
    find node_modules -xtype l -delete
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/stylelint-lsp}
    mv {dist,node_modules} $out/lib/stylelint-lsp
    chmod a+x $out/lib/stylelint-lsp/dist/index.js
    ln -s $out/lib/stylelint-lsp/dist/index.js $out/bin/stylelint-lsp

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Stylelint Language Server";
    homepage = "https://github.com/bmatcuk/stylelint-lsp";
    license = lib.licenses.mit;
    mainProgram = "stylelint-lsp";
    maintainers = with lib.maintainers; [
      gepbird
    ];
    platforms = lib.platforms.unix;
  };
})
