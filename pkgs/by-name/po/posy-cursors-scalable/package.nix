{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  hyprcursor,
  inkscape,
  xcursorgen,
  python3,
  makeFontsConf,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "posy-cursors-scalable";
  version = "1.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Morxemplum";
    repo = "posys-cursor-scalable";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tbNMFTam2msn3z+COLr/CWXEVIuLR/6o/uaNF3kzs38=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    hyprcursor
    inkscape
    xcursorgen
    python3
  ];

  env.FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ ]; };

  postPatch = ''
    patchShebangs plasma_themes/src/build_tools
  '';

  buildPhase = ''
    runHook preBuild

    export HOME="$(mktemp -d)"

    pushd plasma_themes/src/build_tools > /dev/null
    for theme in 1 2 3 4; do
      echo "$theme" | ./build.sh
    done
    popd > /dev/null

    for variant in white black mono mono_black; do
      hyprcursor-util --create "hyprcursor_themes/$variant" --output hyprcursor_themes
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/icons"
    cp -r plasma_themes/posys_* "$out/share/icons"

    for theme in hyprcursor_themes/theme_*; do
      name=$(basename "$theme")
      cp -r "$theme" "$out/share/icons/''${name#theme_}"
    done

    runHook postInstall
  '';

  # Check the installed themes as upstream build.sh ignores inkscape failures
  # A successful build can still ship missing or corrupt cursors
  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    fail() {
      echo "installCheck FAILED: $1" >&2
      exit 1
    }

    for theme in posys_cursor_scalable{,_black,_mono,_mono_black}; do
      dir="$out/share/icons/$theme"
      [[ -f "$dir/index.theme" ]] || fail "$theme: missing index.theme"
      [[ -f "$dir/cursors_scalable/default/default.svg" ]] || fail "$theme: missing scalable default cursor"
      [[ -n "$(ls -A "$dir/cursors")" ]] || fail "$theme: cursors directory is empty"
      [[ -e "$dir/cursors/default" ]] || fail "$theme: missing cursors/default"
      while IFS= read -r -d "" cursor; do
        [[ "$(head -c4 "$cursor")" == "Xcur" ]] || fail "$theme: ''${cursor##*/} lacks the Xcur magic"
      done < <(find "$dir/cursors" -type f -print0)
      echo "installCheck: xcursor theme $theme OK"
    done

    for theme in Posys-Cursor-Scalable{,-Black,-Mono,-Mono-Black}; do
      dir="$out/share/icons/$theme"
      [[ -f "$dir/manifest.hl" ]] || fail "$theme: missing manifest.hl"
      [[ -n "$(ls -A "$dir/hyprcursors")" ]] || fail "$theme: hyprcursors directory is empty"
      echo "installCheck: hyprcursor theme $theme OK"
    done

    broken=$(find "$out" -xtype l)
    [[ -z "$broken" ]] || fail "broken symlinks found:$broken"

    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Michiel De Boer (Posy)'s infamous cursor theme, made scalable with SVGs";
    homepage = "https://github.com/Morxemplum/posys-cursor-scalable";
    license = lib.licenses.cc-by-nc-40;
    maintainers = with lib.maintainers; [ aaravrav ];
    platforms = lib.platforms.linux;
  };
})
