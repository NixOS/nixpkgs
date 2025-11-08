{
  lib,
  stdenvNoCC,
  unzip,
  fetchurl,
  writeShellScript,
  curl,
  xmlstarlet,
  gnused,
  common-updater-scripts,
}:

let
  # Monodraw uses build numbers (tracked via Sparkle appcast)
  # Appcast: https://updates.helftone.com/monodraw/appcast-beta.xml
  build = "118";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "monodraw";
  version = "1.7.1";

  src = fetchurl {
    url = "https://updates.helftone.com/monodraw/downloads/Monodraw-b${build}.zip";
    hash = "sha256-7ti/FXoxNMhSYV7TWTeP8mAnCdqukI0SgDdW6RRQsFc=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -R ./Monodraw.app $out/Applications

    runHook postInstall
  '';

  passthru = {
    inherit build;
    updateScript = writeShellScript "monodraw-update-script" ''
      set -euo pipefail
      export PATH="${
        lib.makeBinPath [
          curl
          xmlstarlet
          gnused
          common-updater-scripts
        ]
      }"

      xml=$(curl -s "https://updates.helftone.com/monodraw/appcast-beta.xml")

      version=$(echo "$xml" | xmlstarlet sel -t -v '//enclosure/@sparkle:shortVersionString')
      build=$(echo "$xml" | xmlstarlet sel -t -v '//enclosure/@sparkle:version')

      # Update build number in let binding
      sed -i "s/build = \"[0-9]*\"/build = \"$build\"/" pkgs/by-name/mo/monodraw/package.nix

      # Update version and hash
      update-source-version monodraw "$version"
    '';
  };

  meta = {
    description = "Powerful ASCII art editor designed for the Mac";
    homepage = "https://monodraw.helftone.com/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ delafthi ];
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
