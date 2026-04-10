{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeBinaryWrapper,
  nodejs,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
  testers,
  shadcn,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "shadcn";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "shadcn-ui";
    repo = "ui";
    rev = "shadcn@${finalAttrs.version}";
    hash = "sha256-9dlSAEkl6NgZGT2noVEfstt8TbIy0Fz+/s5L+MWpblg=";
  };

  pnpmWorkspaces = [ "shadcn" ];
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    pnpm = pnpm_9;
    fetcherVersion = 2;
    hash = "sha256-clTcaTar7m2jEX9cMPtSPeBtt17LaMzlwlLXhPKc+kk=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
    pnpmConfigHook
    pnpm_9
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
    find $out/lib/packages/shadcn -name '*.ts' -delete

    makeWrapper ${lib.getExe nodejs} $out/bin/shadcn \
      --inherit-argv0 \
      --add-flags $out/lib/packages/shadcn/dist/index.js

    runHook postInstall
  '';

  dontCheckForBrokenSymlinks = true;

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
