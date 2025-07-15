{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeBinaryWrapper,
  nodejs,
  pnpm_9,
  testers,
  shadcn,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "shadcn";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "shadcn-ui";
    repo = "ui";
    rev = "shadcn@${finalAttrs.version}";
    hash = "sha256-OBLKCj+v5KgYslJGuwLgJHjgcrxLPiiyO5/ucrJ14Ws=";
  };

  pnpmWorkspaces = [ "shadcn" ];
  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    fetcherVersion = 1;
    hash = "sha256-/80LJm65ZRqyfhsNqGl83bsI2wjgVkvrA6Ij4v8rtoQ=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
    pnpm_9.configHook
  ];

  buildPhase = ''
    runHook preBuild

    pnpm run shadcn:build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}
    cp -r {packages,node_modules} $out/lib

    # cleanup
    rm -r $out/lib/packages/{cli,shadcn/src}
    find $out/lib/packages/shadcn -name '*.ts' -delete

    makeWrapper ${lib.getExe nodejs} $out/bin/shadcn \
      --inherit-argv0 \
      --add-flags $out/lib/packages/shadcn/dist/index.js

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = shadcn;
    command = "shadcn --version";
    version = finalAttrs.version;
  };

  meta = {
    changelog = "https://github.com/shadcn-ui/ui/blob/${finalAttrs.src.rev}/packages/shadcn/CHANGELOG.md#${
      builtins.replaceStrings [ "." ] [ "" ] finalAttrs.version
    }";
    description = "Beautifully designed components that you can copy and paste into your apps";
    homepage = "https://ui.shadcn.com/docs/cli";
    license = lib.licenses.mit;
    mainProgram = "shadcn";
    maintainers = with lib.maintainers; [ getpsyched ];
    platforms = lib.platforms.all;
  };
})
