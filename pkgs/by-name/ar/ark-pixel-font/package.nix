{
  lib,
  python312Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python312Packages.buildPythonPackage rec {
  pname = "ark-pixel-font";
  version = "2025.08.24";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "TakWolf";
    repo = "ark-pixel-font";
    tag = version;
    hash = "sha256-kxct994UmZhJBMlXZmayN24eiKqeG9T7GdyfsjBYpn0=";
  };

  dependencies = with python312Packages; [
    pixel-font-builder
    pixel-font-knife
    unidata-blocks
    character-encoding-utils
    pyyaml
    pillow
    beautifulsoup4
    jinja2
    loguru
    cyclopts
  ];

  buildPhase = ''
    runHook preBuild

    python -m tools.cli --cleanup

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm444 build/outputs/*.bdf -t $out/share/fonts/bdf
    install -Dm444 build/outputs/*.otf -t $out/share/fonts/opentype
    install -Dm444 build/outputs/*.ttf -t $out/share/fonts/truetype
    install -Dm444 build/outputs/*.woff2 -t $out/share/fonts/woff2
    install -Dm444 build/outputs/*.pcf -t $out/share/fonts/pcf
    install -Dm444 build/outputs/*.otc -t $out/share/fonts/otc
    install -Dm444 build/outputs/*.ttc -t $out/share/fonts/ttc

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open source pan-CJK pixel font";
    homepage = "https://ark-pixel-font.takwolf.com/";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ h7x4 ];
    platforms = lib.platforms.all;
  };
}
