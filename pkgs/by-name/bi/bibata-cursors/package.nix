{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchzip,
  xcursorgen,
  librsvg,
  python3,
  customThemes ? null,
  writeText,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bibata-cursors";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "rtgiskard";
    repo = "bibata_cursor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Ro/upo5PVzw/fDdEbbKINWyyI+tf/7vdLj/RuS2Q060=";
  };

  nativeBuildInputs = [
    xcursorgen
    librsvg
    python3
  ];

  buildPhase = ''
    runHook preBuild

    ${
      if builtins.isAttrs customThemes then
        let
          json = builtins.toJSON customThemes;
        in
        "cp ${writeText "bibata-cursors-custom-themes.json" json} config/render.json"
      else if builtins.isNull customThemes then
        ""
      else
        "cp ${customThemes} config/render.json"
    }

    python3 src/cursor_utils.py --svg --hypr --x11 --out-dir ./out

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -r ./out/Bibata-* $out/share/icons/

    runHook postInstall
  '';

  meta = {
    description = "Bibata Cursor, with support for hyprcursor, Xcursor and scalable_cursor.";
    homepage = "https://github.com/rtgiskard/bibata_cursor";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      rawkode
    ];
  };
})
