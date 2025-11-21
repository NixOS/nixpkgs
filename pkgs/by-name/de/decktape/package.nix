{
  fetchFromGitHub,
  buildNpmPackage,
  lib,
  chromium,
}:
buildNpmPackage rec {
  name = "decktape";
  version = "3.15.0";

  src = fetchFromGitHub {
    owner = "astefanutti";
    repo = "decktape";
    rev = "v${version}";
    hash = "sha256-SsdjqkMEVD0pVgIZ9Upmrz/1KOWcb1KUy/v/xTCVGc0=";
  };

  npmDepsHash = "sha256-Z5fLGMvxVhM8nW81PQ5ZFPHK6m2uoYUv0A4XsTa3Z2Y=";
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
