{
  fetchFromGitHub,
  buildNpmPackage,
  lib,
  chromium,
}:
buildNpmPackage rec {
  pname = "decktape";
  version = "3.17.0";

  src = fetchFromGitHub {
    owner = "astefanutti";
    repo = "decktape";
    rev = "v${version}";
    hash = "sha256-BA6irs2qksuaIW1b/N/zF2kdyOAM5mY8/YcxlDi0bXE=";
  };

  npmDepsHash = "sha256-EuioTVb4yueju6XlOgQUgqF8Z4ZXC6qqzW/2+fi8DeA=";
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
