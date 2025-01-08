{
  stdenv,
  lib,
  fetchurl,
  undmg,
  makeWrapper,
  writeShellApplication,
  curl,
  cacert,
  gnugrep,
  common-updater-scripts,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "3.5.1";
  pname = "grandperspective";

  src = fetchurl {
    inherit (finalAttrs) version;
    url = "mirror://sourceforge/grandperspectiv/GrandPerspective-${
      lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version
    }.dmg";
    hash = "sha256-ZD6XUtsbwxHe3MYdCH9I/pYBCGgilPhhbYQChr0wCj4=";
  };

  sourceRoot = "GrandPerspective.app";
  buildInputs = [ undmg ];
  nativeBuildInputs = [ makeWrapper ];
  # Create a trampoline script in $out/bin/ because a symlink doesn’t work for
  # this app.
  installPhase = ''
    mkdir -p "$out/Applications/GrandPerspective.app" "$out/bin"
    cp -R . "$out/Applications/GrandPerspective.app"
    makeWrapper "$out/Applications/GrandPerspective.app/Contents/MacOS/GrandPerspective" "$out/bin/grandperspective"
  '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "grandperspective-update-script";
    runtimeInputs = [
      curl
      cacert
      gnugrep
      common-updater-scripts
    ];
    text = ''
      url="https://sourceforge.net/p/grandperspectiv/documentation/ci/master/tree/CHANGES.txt?format=raw"
      version=$(curl -s "$url" | grep -oP 'Version \K[0-9.]+(?=,)' | head -n 1)
      update-source-version grandperspective "$version"
    '';
  });

  meta = {
    description = "Open-source macOS application to analyze disk usage";
    longDescription = ''
      GrandPerspective is a small utility application for macOS that graphically shows the disk usage within a file
      system. It can help you to manage your disk, as you can easily spot which files and folders take up the most
      space. It uses a so called tree map for visualisation. Each file is shown as a rectangle with an area proportional to
      the file's size. Files in the same folder appear together, but their placement is otherwise arbitrary.
    '';
    mainProgram = "grandperspective";
    homepage = "https://grandperspectiv.sourceforge.net";
    license = lib.licenses.gpl2Only;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [
      eliandoran
      DimitarNestorov
    ];
    platforms = lib.platforms.darwin;
  };

})
