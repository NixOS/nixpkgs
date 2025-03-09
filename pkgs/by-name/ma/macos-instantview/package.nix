{
  stdenvNoCC,
  fetchurl,
  lib,
  _7zz,
}:

stdenvNoCC.mkDerivation (self: {
  pname = "instantview";
  version = "V3.22R0002";

  src = fetchurl {
    url = "https://www.siliconmotion.com/downloads/macOS_InstantView_${self.version}.dmg";
    hash = "sha256-PdgX9zCrVYtNbuOCYKVo9cegCG/VY7QXetivVsUltbg=";
  };

  nativeBuildInputs = [ _7zz ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/Applications"

    # Extract the DMG using 7zip
    7zz x "$src" -oextracted -y

    # Move the extracted contents to $out
    cp -r extracted/* "$out/Applications/"

    runHook postInstall
  '';

  meta = {
    platforms = lib.platforms.darwin;
    description = "SM76x driver: InstantView™ Enables USB Docking Station to Plugin-and-display! Enlarge Your Screen to Learn / Work from Home!";
    homepage = "https://www.siliconmotion.com/events/instantview/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ aspauldingcode ];
  };
})
