{
  lib,
  stdenv,
  fetchFromGitHub,
  jq,
  nodejs,
  jitsi-meet,
  element-call,
  fetchPnpmDeps,
  pnpm_11,
  pnpmConfigHook,
  faketty,
}:

let
  pnpm = pnpm_11;
  element-call-component = element-call.overrideAttrs (
    finalAttrs: previousAttrs: {
      pname = "element-call-component";
      version = "0-unstable-2026-10-11";

      src = fetchFromGitHub {
        owner = "element-hq";
        repo = "element-call";
        rev = "6438c18b73773904557baa0b359f3ebed1be76e2";
        hash = "sha256-A2+siwOyGjqoC/9anm5X3CsRe8iGMU+koYuASCbgjoE=";
      };

      pnpmDeps = fetchPnpmDeps {
        inherit (finalAttrs) pname version src;
        inherit pnpm;
        fetcherVersion = 4;
        hash = "sha256-azoAg2QMTyDVPK7tN5M8o9rycAnpQNcozDjInX6gQv8=";
      };

      matrix-js-sdk = element-call.matrix-js-sdk.overrideAttrs (sdkAttrs: {
        version = "43.0.0-unstable-2026-10-01";

        src = fetchFromGitHub {
          owner = "matrix-org";
          repo = "matrix-js-sdk";
          rev = "fa4772a4ddd335a5a8bfbf8bb21df49b70f7a999";
          hash = "sha256-ldquetRKrjgI+YN2zp6mXzqEqSpBFqKCwJw8UEoD+gY=";
        };

        pnpmDeps = fetchPnpmDeps {
          inherit (sdkAttrs) pname version src;
          inherit pnpm;
          fetcherVersion = 4;
          hash = "sha256-TPr/z7D9FkvToUE1gQEZwXMMllx5U224s8+O9yNT2BM=";
        };
      });

      buildPhase = ''
        runHook preBuild
        cp -r ${finalAttrs.matrix-js-sdk}/* node_modules/matrix-js-sdk/
        pnpm build:component
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        cp -r component $out
        runHook postInstall
      '';

      passthru.tests = { };
      meta = previousAttrs.meta // {
        changelog = "https://github.com/element-hq/element-call/commits/${finalAttrs.src.rev}";
        description = "Element Call React component";
      };
    }
  );
  noPhoningHome = {
    disable_guests = true; # disable automatic guest account registration at matrix.org
  };
  # Do not inherit jitsi-meet's knownVulnerabilities (libolm).
  # https://github.com/NixOS/nixpkgs/pull/335753
  # https://github.com/NixOS/nixpkgs/pull/334638
  jitsi-meet-override = jitsi-meet.overrideAttrs (previousAttrs: {
    meta = removeAttrs previousAttrs.meta [ "knownVulnerabilities" ];
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "element-web";
  version = "1.12.33";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "element-web";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eNa91kkOPH4su4xp5Nejrd6Y1gnrNjHhjfoLRckpxAY=";
  };

  pnpmDeps = fetchPnpmDeps {
    pname = "element";
    inherit (finalAttrs) version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-x/fZlTMVrsYUzZJWZ6RTeDhrKh0Si+mnTbx0eESP/qM=";
  };

  nativeBuildInputs = [
    jq
    nodejs
    pnpm
    pnpmConfigHook
    faketty
  ];

  # faketty is required to work around a bug in nx.
  # See: https://github.com/nrwl/nx/issues/22445
  buildPhase = ''
    runHook preBuild

    cp -r ${element-call-component}/dist apps/web/node_modules/@element-hq/element-call-component/

    cd apps/web

    export VERSION=${finalAttrs.version}
    faketty pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -R webapp $out
    cp ${jitsi-meet-override}/libs/external_api.min.js $out/jitsi_external_api.min.js
    echo "${finalAttrs.version}" > "$out/version"
    jq -s '.[0] * $conf' "config.sample.json" --argjson "conf" '${builtins.toJSON noPhoningHome}' > "$out/config.json"

    runHook postInstall
  '';

  passthru = { inherit element-call-component; };

  meta = {
    description = "Matrix client for the web";
    homepage = "https://element.io/";
    changelog = "https://github.com/element-hq/element-web/blob/v${finalAttrs.version}/CHANGELOG.md";
    teams = [ lib.teams.matrix ];
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.all;
  };
})
