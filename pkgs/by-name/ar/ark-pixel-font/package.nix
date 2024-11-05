{
  lib,
  python312Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python312Packages.buildPythonPackage rec {
  pname = "ark-pixel-font";
  version = "2025.01.06";

  src = fetchFromGitHub {
    owner = "TakWolf";
    repo = "ark-pixel-font";
    tag = version;
    hash = "sha256-PGhhKWHDpvOqa3vaI40wuIsAEdWGb62cN7QJeHQqiss=";
  };

  format = "other";

  nativeBuildInputs = with python312Packages; [
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

    python -m tools.cli --cleanup --font-formats otf pcf

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm444 build/outputs/*.otf -t $out/share/fonts/opentype
    # install -Dm444 build/outputs/*.ttf -t $out/share/fonts/truetype
    # install -Dm444 build/outputs/*.woff2 -t $out/share/fonts/woff2
    # install -Dm444 build/outputs/*.bdf -t $out/share/fonts/bdf
    install -Dm444 build/outputs/*.pcf -t $out/share/fonts/pcf
    # install -Dm444 build/outputs/*.otc -t $out/share/fonts/otc
    # install -Dm444 build/outputs/*.ttc -t $out/share/fonts/ttc

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/TakWolf/ark-pixel-font";
    description = "Open source pan-CJK pixel font";
    platforms = lib.platforms.all;
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [
      TakWolf
      h7x4
    ];
  };
}
