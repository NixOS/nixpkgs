{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk-engine-murrine,
  jdupes,
  sassc,
  accent ? [ "default" ],
  shade ? "dark",
  size ? "standard",
  tweaks ? [ ],
}:
let
  validAccents = [
    "default"
    "purple"
    "pink"
    "red"
    "orange"
    "yellow"
    "green"
    "teal"
    "grey"
    "all"
  ];
  validShades = [
    "light"
    "dark"
  ];
  validSizes = [
    "standard"
    "compact"
  ];
  validTweaks = [
    "frappe"
    "macchiato"
    "black"
    "float"
    "outline"
    "macos"
  ];

  single = x: lib.optional (x != null) x;
  pname = "Catppuccin-GTK";
in
lib.checkListOfEnum "${pname} Valid theme accent(s)" validAccents accent lib.checkListOfEnum
  "${pname} Valid shades"
  validShades
  (single shade)
  lib.checkListOfEnum
  "${pname} Valid sizes"
  validSizes
  (single size)
  lib.checkListOfEnum
  "${pname} Valid tweaks"
  validTweaks
  tweaks

  stdenv.mkDerivation
  {
    pname = "magnetic-${lib.toLower pname}";
    version = "0-unstable-2025-04-25";

    src = fetchFromGitHub {
      owner = "Fausto-Korpsvart";
      repo = "Catppuccin-GTK-Theme";
      rev = "c961826d027ed93fae12a9a309616e36d140e6b9";
      hash = "sha256-7F4FrhM+kBFPeLp2mjmYkoDiF9iKDUkC27LUBuFyz7g=";
    };

    nativeBuildInputs = [
      jdupes
      sassc
    ];

    propagatedUserEnvPkgs = [ gtk-engine-murrine ];

    postPatch = ''
      find -name "*.sh" -print0 | while IFS= read -r -d ''' file; do
        patchShebangs "$file"
      done
    '';

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/themes

      ./themes/install.sh \
        --name ${pname} \
        ${toString (map (x: "--theme " + x) accent)} \
        ${lib.optionalString (shade != null) ("--color " + shade)} \
        ${lib.optionalString (size != null) ("--size " + size)} \
        ${toString (map (x: "--tweaks " + x) tweaks)} \
        --dest $out/share/themes

      jdupes --quiet --link-soft --recurse $out/share

      runHook postInstall
    '';

    meta = {
      description = "GTK Theme with Catppuccin colour scheme";
      homepage = "https://github.com/Fausto-Korpsvart/Catppuccin-GTK-Theme";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [ icy-thought ];
      platforms = lib.platforms.all;
    };
  }
