{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  pnpm,
  nodejs,
  vscode-utils,
  nix-update-script,
}:

let
  vsix = stdenvNoCC.mkDerivation (finalAttrs: {
    name = "kilo-code-${finalAttrs.version}.vsix";
    pname = "kilo-code-vsix";
    version = "4.124.0";

    src = fetchFromGitHub {
      owner = "Kilo-Org";
      repo = "kilocode";
      tag = "v${finalAttrs.version}";
      hash = "sha256-Dy0dd07pWsSbrO6BX7GEYf7CunXD0itaeIFRv9mQJks=";
    };

    pnpmDeps = pnpm.fetchDeps {
      inherit (finalAttrs) pname version src;
      fetcherVersion = 2;
      hash = "sha256-hxgzmJD+Sl7E+ape1M1/Xl8XLtAhtht3AE45zHFctsQ=";
    };

    nativeBuildInputs = [
      nodejs
      pnpm.configHook
      pnpm
    ];

    buildPhase = ''
      runHook preBuild

      node --run build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      cp ./bin/kilo-code-$version.vsix $out

      runHook postInstall
    '';
  });
in
vscode-utils.buildVscodeExtension (finalAttrs: {
  pname = "kilo-code";
  inherit (finalAttrs.src) version;

  vscodeExtPublisher = "kilocode";
  vscodeExtName = "Kilo-Code";
  vscodeExtUniqueId = "${finalAttrs.vscodeExtPublisher}.${finalAttrs.vscodeExtName}";

  src = vsix;

  unpackPhase = ''
    runHook preUnpack

    unzip $src

    runHook postUnpack
  '';

  passthru = {
    vsix = finalAttrs.src;
    updateScript = nix-update-script {
      attrPath = "vscode-extensions.kilocode.kilo-kode.vsix";
    };
  };

  meta = {
    description = "Open Source AI coding assistant for planning, building, and fixing code";
    homepage = "https://kilocode.ai";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=kilocode.Kilo-Code";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
  };
})
