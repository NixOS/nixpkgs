{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3Packages,
}:

stdenvNoCC.mkDerivation rec {
  pname = "jetbrains-mono";
  version = "2.304";

  src = fetchFromGitHub {
    owner = "jetbrains";
    repo = "jetbrainsmono";
    rev = "v${version}";
    hash = "sha256-SW9d5yVud2BWUJpDOlqYn1E1cqicIHdSZjbXjqOAQGw=";
  };

  env."PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION" = "python";

  nativeBuildInputs = [
    python3Packages.gftools
  ];

  buildPhase = ''
    runHook preBuild
    gftools builder sources/config.yaml
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 -t "$out/share/fonts/opentype/" fonts/otf/*.otf
    install -Dm644 -t "$out/share/fonts/truetype/" fonts/ttf/*.ttf
    install -Dm644 -t "$out/share/fonts/truetype/" fonts/variable/*.ttf
    install -Dm644 -t "$out/share/fonts/WOFF2/" fonts/webfonts/*.woff2
    runHook postInstall
  '';

  meta = {
    description = "Typeface made for developers";
    homepage = "https://jetbrains.com/mono/";
    changelog = "https://github.com/JetBrains/JetBrainsMono/blob/v${version}/Changelog.md";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ vinnymeller ];
    platforms = lib.platforms.all;
  };
}
