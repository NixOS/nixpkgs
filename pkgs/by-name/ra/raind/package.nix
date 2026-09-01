{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "raind";
  version = "0.2.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rokuroo171";
    repo = "raind";
    rev = "v${version}";
    hash = "sha256-zH5RP1mCxLdyqcDLlMG8zwodsEsez2XePtiWO+m/ST4=";
  };

  vendorHash = "sha256-8UprJXRLFO3giWAm8k+vbNz7HPYwKW7cD36qc3hEkzE=";

  meta = {
    description = "Terminal weather screensaver with four modes: rain, thunder, snow, meteor";
    homepage = "https://github.com/rokuroo171/raind";
    license = lib.licenses.mit;
    mainProgram = "raind";
    maintainers = with lib.maintainers; [ rokuroo171 ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
