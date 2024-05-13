{ lib
, python312Packages
, fetchFromGitHub
, nix-update-script
}:

python312Packages.buildPythonPackage rec {
  pname = "ark-pixel-font";
  version = "2024.05.12";

  src = fetchFromGitHub {
    owner = "TakWolf";
    repo = "ark-pixel-font";
    rev = "refs/tags/${version}";
    hash = "sha256-PGhhKWHDpvOqa3vaI40wuIsAEdWGb62cN7QJeHQqiss=";
  };

  format = "other";

  nativeBuildInputs = with python312Packages; [
    pixel-font-builder
    unidata-blocks
    character-encoding-utils
    pypng
    pillow
    beautifulsoup4
    jinja2
    gitpython
  ];

  buildPhase = ''
    runHook preBuild

    python build.py

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm444 build/outputs/*.bdf -t $out/share/fonts/bdf
    install -Dm444 build/outputs/*.otf -t $out/share/fonts/opentype
    install -Dm444 build/outputs/*.ttf -t $out/share/fonts/truetype
    install -Dm444 build/outputs/*.woff2 -t $out/share/fonts/woff2

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
