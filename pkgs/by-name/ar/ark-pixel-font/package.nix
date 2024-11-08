{
  lib,
  python312Packages,
  fetchFromGitHub,
  nix-update-script,
  fetchPypi,
}:

let
  pixel-font-builder-compat = python312Packages.pixel-font-builder.overrideAttrs rec {
    version = "0.0.26";
    src = fetchPypi {
      inherit version;
      pname = "pixel_font_builder";
      hash = "sha256-bgs2FbOA5tcUXe5+KuVztWGAv5yFxQNBaiZMeZ+ic+8=";
    };
  };
in
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
    pixel-font-builder-compat
    unidata-blocks
    character-encoding-utils
    pypng
    pillow
    beautifulsoup4
    jinja2
    gitpython
  ];

  # By default build.py builds a LOT of extraneous artifacts we don't need.
  patches = [ ./limit-builds.patch ];

  buildPhase = ''
    runHook preBuild

    # Too much debug output would break Hydra, so this jankness has to be here for it to build at all.
    # I wish there's a builtin way to set the log level without modifying the script itself...
    python3 build.py 2>&1 >/dev/null | grep -E '^(INFO|WARN|ERROR)'

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
