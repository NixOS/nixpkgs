{
  lib,
  fetchFromGitHub,
  buildGoModule,
  buildNpmPackage,
  fetchurl,
  makeWrapper,
  nodejs,
  stdenvNoCC,
  nix-update-script,
}:

let
  version = "0.45.0";
  src = fetchFromGitHub {
    owner = "pocket-id";
    repo = "pocket-id";
    tag = "v${version}";
    hash = "sha256-x5Y3ArkIPxiE6avk9DNyFdfkc/pY6h3JH3PZCS8U/GM=";
  };

  backend = buildGoModule {
    pname = "pocket-id-backend";
    inherit version src;

    sourceRoot = "${src.name}/backend";

    vendorHash = "sha256-mqpBP+A2X5ome1Ppg/Kki0C+A77jFtWzUjI/RN+ZCzg=";

    preFixup = ''
      mv $out/bin/cmd $out/bin/pocket-id-backend
    '';
  };

  frontend = buildNpmPackage (finalAttrs: {
    pname = "pocket-id-frontend";
    inherit version src;

    sourceRoot = "${src.name}/frontend";

    npmDepsHash = "sha256-cpmZzlz+wusfRLN4iIGdk+I4SWrX/gk2fbhg+Gg3paw=";
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
      rm -r node_modules/{lucide-svelte,bits-ui,jiti,@swc,.bin}
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
  });

in
stdenvNoCC.mkDerivation rec {
  pname = "pocket-id";
  inherit
    version
    src
    backend
    frontend
    ;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    ln -s ${backend}/bin/pocket-id-backend $out/bin/pocket-id-backend
    ln -s ${frontend}/bin/pocket-id-frontend $out/bin/pocket-id-frontend

    runHook postInstall
  '';

  passthru = {
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
    changelog = "https://github.com/pocket-id/pocket-id/releases/tag/v${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      gepbird
      ymstnt
    ];
    platforms = lib.platforms.unix;
  };
}
