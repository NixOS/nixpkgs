{
  lib,
  stdenv,
  fetchFromGitHub,
  jq,
  nodejs,
  jitsi-meet,
  fetchPnpmDeps,
  pnpm,
  pnpmConfigHook,
  faketty,
}:

let
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
  version = "1.12.17";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "element-web";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9YUdYVsv0k9Oc55aS3pOFttcJ/kNzyu75fyq4oV6wLo=";
  };

  pnpmDeps = fetchPnpmDeps {
    pname = "element";
    inherit (finalAttrs) version src;
    fetcherVersion = 3;
    hash = "sha256-aq5Z2n/rzOpgrqWvksU48kUQ4Qi5SaVHo4U54wZIAzg=";
  };

  nativeBuildInputs = [
    jq
    nodejs
    pnpm
    pnpmConfigHook
    faketty
  ];

  preBuild = ''
    substituteInPlace packages/module-api/node_modules/.bin/vite \
      --replace-fail "/usr/bin/env node" "${nodejs}/bin/node"
  '';

  # faketty is required to work around a bug in nx.
  # See: https://github.com/nrwl/nx/issues/22445
  buildPhase = ''
    runHook preBuild

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

  meta = {
    description = "Glossy Matrix collaboration client for the web";
    homepage = "https://element.io/";
    changelog = "https://github.com/element-hq/element-web/blob/v${finalAttrs.version}/CHANGELOG.md";
    teams = [ lib.teams.matrix ];
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.all;
  };
})
