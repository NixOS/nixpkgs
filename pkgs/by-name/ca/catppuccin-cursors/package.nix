{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  inkscape,
  just,
  xcursorgen,
  catppuccin-whiskers,
  python3,
  python3Packages,
  zip,
}:
let
  dimensions = {
    palette = [
      "frappe"
      "latte"
      "macchiato"
      "mocha"
    ];
    color = [
      "Blue"
      "Dark"
      "Flamingo"
      "Green"
      "Lavender"
      "Light"
      "Maroon"
      "Mauve"
      "Peach"
      "Pink"
      "Red"
      "Rosewater"
      "Sapphire"
      "Sky"
      "Teal"
      "Yellow"
    ];
  };
  variantName = { palette, color }: palette + color;
  variants = lib.mapCartesianProduct variantName dimensions;
  version = "2.0.0";
in
stdenvNoCC.mkDerivation {
  pname = "catppuccin-cursors";
  inherit version;

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "cursors";
    rev = "v${version}";
    hash = "sha256-qis6p+/m7+DdRDYzLq9yB2eZGpfZe5z5xRsa/1HoIG4=";
  };

  nativeBuildInputs = [
    just
    inkscape
    xcursorgen
    catppuccin-whiskers
    python3
    python3Packages.pyside6
    zip
  ];

  outputs = variants ++ [ "out" ]; # dummy "out" output to prevent breakage

  outputsToInstall = [ ];

  buildPhase = ''
    runHook preBuild

    patchShebangs .

    just all

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    for output in $(getAllOutputNames); do
      if [ "$output" != "out" ]; then
        local outputDir="''${!output}"
        local iconsDir="$outputDir"/share/icons

        mkdir -p "$iconsDir"

        # Convert to kebab case with the first letter of each word capitalized
        local variant=$(sed 's/\([A-Z]\)/-\1/g' <<< "$output")
        local variant=''${variant,,}

        mv "dist/catppuccin-$variant-cursors" "$iconsDir"
      fi
    done

    # Needed to prevent breakage
    mkdir -p "$out"

    runHook postInstall
  '';

  meta = {
    description = "Catppuccin cursor theme based on Volantes";
    homepage = "https://github.com/catppuccin/cursors";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ dixslyf ];
  };
}
