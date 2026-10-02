{
  fetchgit,
  guile,
  guile-cairo,
  lib,
  libxkbcommon,
  makeBinaryWrapper,
  pango,
  pkg-config,
  river,
  stdenv,
  wayland,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gliver";
  version = "0.0.3";

  src = fetchgit {
    url = "https://codeberg.org/ebeem/gliver";
    rev = "ad947d2de4cc854ea2cbd7b30624a59b6b52a176";
    hash = "sha256-RlhJvM3hsFiy/SW4Pw30dKB/iMlqqVUZpSDFXxYZF4c=";
  };

  __structuredAttrs = true;

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  strictDeps = true;

  nativeBuildInputs = [
    guile
    guile-cairo
    libxkbcommon
    makeBinaryWrapper
    pango
    pkg-config
    river
    wayland
  ];

  buildInputs = [
    guile
    guile-cairo
    libxkbcommon
    pango
    river
    wayland
  ];

  postInstall = ''
    wrapProgram $out/bin/gliver \
      --prefix GUILE_LOAD_PATH : "$out/${guile.siteDir}:$GUILE_LOAD_PATH" \
      --prefix GUILE_LOAD_COMPILED_PATH : "$out/${guile.siteCcacheDir}:$GUILE_LOAD_COMPILED_PATH"
    wrapProgram $out/bin/gliver-repl \
      --prefix GUILE_LOAD_PATH : "$out/${guile.siteDir}:$GUILE_LOAD_PATH" \
      --prefix GUILE_LOAD_COMPILED_PATH : "$out/${guile.siteCcacheDir}:$GUILE_LOAD_COMPILED_PATH"
  '';

  meta = {
    description = "Guile-based window manager for Wayland";
    mainProgram = "gliver";
    homepage = "https://codeberg.org/ebeem/gliver";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ mra ];
    inherit (river.meta) platforms;
  };
})
