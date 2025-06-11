{
  lib,
  stdenvNoCC,
  fetchzip,
  families ? [ ],
}:
let
  version = import ./version.nix;
  availableFamilies = import ./hashes.nix;

  availableFamilyNames = builtins.attrNames availableFamilies;
  selectedFamilies = if (families == [ ]) then availableFamilyNames else families;

  unknownFamilies = lib.subtractLists availableFamilyNames families;
in
assert lib.assertMsg (unknownFamilies == [ ]) "Unknown font(s): ${toString unknownFamilies}";
stdenvNoCC.mkDerivation {
  pname = "ibm-plex";
  inherit version;

  srcs = builtins.map (
    family:
    fetchzip {
      url = "https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-${family}%40${version}/ibm-plex-${family}.zip";
      hash = availableFamilies.${family};
    }
  ) selectedFamilies;

  dontUnpack = true;
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    find $srcs -type f -name '*.otf' -exec install -Dm644 {} -t $out/share/fonts/opentype \;
    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "IBM Plex Typeface";
    homepage = "https://www.ibm.com/plex/";
    changelog = "https://github.com/IBM/plex/raw/v${version}/CHANGELOG.md";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      romildo
      ryanccn
    ];
  };
}
