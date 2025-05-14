{
  lib,
  fetchFromGitHub,
  buildGoModule,
  buildNpmPackage,
  makeWrapper,
  nodejs,
  stdenvNoCC,
  nixosTests,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pocket-id";
  version = "0.53.0";

  src = fetchFromGitHub {
    owner = "pocket-id";
    repo = "pocket-id";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3lW4jPh9YElgpBcIooGQ2zZbNwC/rz7CABsp7ScTxyQ=";
  };

  backend = buildGoModule {
    pname = "pocket-id-backend";
    inherit (finalAttrs) version src;

    sourceRoot = "${finalAttrs.src.name}/backend";

    vendorHash = "sha256-wOrYIhOrUxz22Ay2A26FTrPJA8YRgdRihP78Ls8VgNM=";

    preFixup = ''
      mv $out/bin/cmd $out/bin/pocket-id-backend
    '';
  };

  frontend = buildNpmPackage {
    pname = "pocket-id-frontend";
    inherit (finalAttrs) version src;

    sourceRoot = "${finalAttrs.src.name}/frontend";

    npmDepsHash = "sha256-UjYAndueuJU07unbNFoTQHqRFkdyaBKHyT4k3Ex4pg0=";
    npmFlags = [ "--legacy-peer-deps" ];

    nativeBuildInputs = [
      makeWrapper
    ];

    installPhase = ''
      runHook preInstall

      # even though vite build creates most of the minified js files,
      # it still needs a few packages from node_modules, try to strip that
      npm prune --omit=dev --omit=optional $npmFlags
      # larger seemingly unused packages
      rm -r node_modules/{lucide-svelte,jiti,@swc,.bin}
      # unused file types
      for pattern in '*.map' '*.map.js' '*.ts'; do
        find . -type f -name "$pattern" -exec rm {} +
      done

      mkdir -p $out/{bin,lib/pocket-id-frontend}
      cp -r build $out/lib/pocket-id-frontend/dist
      cp -r node_modules $out/lib/pocket-id-frontend/node_modules
      makeWrapper ${lib.getExe nodejs} $out/bin/pocket-id-frontend \
        --add-flags $out/lib/pocket-id-frontend/dist/index.js

      runHook postInstall
    '';
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    ln -s ${finalAttrs.backend}/bin/pocket-id-backend $out/bin/pocket-id-backend
    ln -s ${finalAttrs.frontend}/bin/pocket-id-frontend $out/bin/pocket-id-frontend

    runHook postInstall
  '';

  passthru = {
    tests = {
      inherit (nixosTests) pocket-id;
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "backend"
        "--subpackage"
        "frontend"
      ];
    };
  };

  meta = {
    description = "OIDC provider with passkeys support";
    homepage = "https://pocket-id.org";
    changelog = "https://github.com/pocket-id/pocket-id/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      gepbird
      marcusramberg
      ymstnt
    ];
    platforms = lib.platforms.unix;
  };
})
