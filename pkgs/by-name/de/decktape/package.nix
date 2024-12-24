{
  fetchFromGitHub,
  buildNpmPackage,
  lib,
  chromium,
}:
buildNpmPackage rec {
  name = "decktape";
  version = "3.14.0";

  src = fetchFromGitHub {
    owner = "astefanutti";
    repo = "decktape";
    rev = "v${version}";
    hash = "sha256-V7JoYtwP7iQYFi/WhFpkELs7mNKF6CqrMyjWhxLkcTA=";
  };

  npmDepsHash = "sha256-rahrIhB0GhqvzN2Vu6137Cywr19aQ70gVbNSSYzFD+s=";
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
