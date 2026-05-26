{
  php84,
  php ? php84.withExtensions (
    { enabled, all }:
    with all;
    enabled
    ++ [
      intl
      zip
    ]
  ),

  lib,
  fetchFromGitHub,
  stdenv,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs_20,
}:
let
  version = "v1.0.0-beta33";

  src = fetchFromGitHub {
    owner = "pelican-dev";
    repo = "panel";
    tag = version;
    sha256 = "sha256-+nP6J+ZdtWtR4bo8DQkvnS5jVbjvxITnWvwkR+izOYY=";
  };

  composerVendor = stdenv.mkDerivation {
    name = "pelican-panel-vendor";
    inherit version src;

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-lGqvAHN5BWa7qv3XKoa/pLtal+Ki1jCemc1QkUwOvS0=";

    nativeBuildInputs = [
      php
      php.packages.composer
    ];

    buildPhase = ''
      COMPOSER_HOME=$(mktemp -d) composer install \
        --no-dev --no-interaction --no-scripts --prefer-dist
      COMPOSER_HOME=$(mktemp -d) composer dump-autoload \
        --optimize --no-scripts
    '';

    dontFixup = true;
    installPhase = "cp -r vendor $out";
    __structuredAttrs = true;
  };

  frontendAssets = stdenv.mkDerivation {
    name = "pelican-panel-assets";
    inherit version src;

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-NRcl0OpWRg8U0ppIJDhyfqKBwjbai7K9hx2YWoEHAVM=";

    yarnOfflineCache = fetchYarnDeps {
      yarnLock = "${src}/yarn.lock";
      hash = "sha256-VLero9gHqkh6svauRSwZf2ASpEBu9iQcPUx+J77SR+o=";
    };

    nativeBuildInputs = [
      yarnConfigHook
      yarnBuildHook

      nodejs_20
    ];

    postConfigure = ''
      cp -r ${composerVendor} vendor
      chmod -R u+w vendor
    '';

    installPhase = "cp -r public/build $out";
    __structuredAttrs = true;
  };
in
stdenv.mkDerivation {
  pname = "pelican-panel";
  inherit version src;

  installPhase = ''
    cp -r . $out
    cp -r ${composerVendor} $out/vendor
    cp -r ${frontendAssets} $out/public/build
  '';

  dontFixup = true;

  meta = {
    maintainers = [ lib.maintainers.oskardotglobal ];
    homepage = "https://pelican.dev";
    changelog = "https://github.com/pelican-dev/panel/releases/tag/${version}";
    description = "Game Server panel based on Pterodactyl";
    license = lib.licenses.agpl3Only;
  };

  passthru = { inherit php; };

  strictDeps = true;
  __structuredAttrs = true;
}
