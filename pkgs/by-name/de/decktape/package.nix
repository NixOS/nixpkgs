{
  fetchFromGitHub,
  buildNpmPackage,
  lib,
  chromium,
}:
buildNpmPackage rec {
  pname = "decktape";
  version = "3.16.1";

  src = fetchFromGitHub {
    owner = "astefanutti";
    repo = "decktape";
    rev = "v${version}";
    hash = "sha256-ZsNSQlkzIlawQ9FWG9kjz3bDJAx3X5YHv7LESI0tmpc=";
  };

  npmDepsHash = "sha256-B84p4VBaQMZlhwiwXdF9Ijwpn3MisMlOXWc0E+5R5l8=";
  npmPackFlags = [ "--ignore-scripts" ];

  dontNpmBuild = true;

  env.PUPPETEER_SKIP_DOWNLOAD = 1;

  postFixup = ''
    wrapProgram $out/bin/decktape \
      --add-flags "--chrome-path ${chromium}/bin/chromium" \
      --set PATH ${
        lib.makeBinPath [
          chromium
        ]
      }
  '';

  meta = {
    description = "High-quality PDF exporter for HTML presentation frameworks";
    mainProgram = "decktape";
    homepage = "https://github.com/astefanutti/decktape";
    changelog = "https://github.com/astefanutti/decktape/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fidgetingbits ];
  };
}
