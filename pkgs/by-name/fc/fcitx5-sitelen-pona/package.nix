{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  libime,
  fcitx5,
  qt6Packages,
}:

stdenvNoCC.mkDerivation rec {
  pname = "fcitx5-sitelen-pona";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Toastberries";
    repo = "fcitx5-sitelen-pona";
    tag = "v${version}";
    hash = "sha256-ZLp/p5umewp1seXFPtMevVBXfoNwHXAojYl5jWHHsTU=";
  };

  strictDeps = true;

  nativeBuildInputs = [ libime ];

  buildInputs = [
    fcitx5
    qt6Packages.fcitx5-chinese-addons
  ];

  buildPhase = ''
    runHook preBuild

    mkdir -p fcitx5/table
    for file in table_sources/*; do
      libime_tabledict "$file" "fcitx5/table/$(basename "$file" .txt).dict"
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fcitx5/inputmethod
    mkdir -p $out/share/fcitx5/punctuation
    mkdir -p $out/share/fcitx5/table
    mkdir -p $out/share/icons/hicolor/scalable/status

    for file in fcitx5/inputmethod/*; do
      install -Dm644 "$file" "$out/share/fcitx5/inputmethod/$(basename "$file")"
    done

    for file in fcitx5/punctuation/*; do
      install -Dm644 "$file" "$out/share/fcitx5/punctuation/$(basename "$file")"
    done

    for file in fcitx5/table/*; do
      install -Dm644 "$file" "$out/share/fcitx5/table/$(basename "$file")"
    done

    for icon in icons/*; do
      install -Dm644 "$icon" "$out/share/icons/hicolor/scalable/status/fcitx5-$(basename "$icon")"
    done

    runHook postInstall
  '';

  __structuredAttrs = true;

  meta = {
    inherit (fcitx5.meta) platforms;
    description = "IME using Fcitx5 for writing toki pona's sitelen pona glyphs";
    longDescription = ''
      This tool is an IME using Fcitx5
      With it, you can easily write toki pona's sitelen pona glyphs
      Simply type your words in latin characters, and they'll be changed into sitelen pona
    '';
    homepage = "https://github.com/Toastberries/fcitx5-sitelen-pona";
    changelog = "https://github.com/Toastberries/fcitx5-sitelen-pona/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ssnoer ];
  };
}
