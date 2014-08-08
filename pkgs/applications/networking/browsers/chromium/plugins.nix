{ stdenv
, enablePepperFlash ? false
, enablePepperPDF ? false

, source
}:

with stdenv.lib;

let
  plugins = stdenv.mkDerivation {
    name = "chromium-binary-plugins";

    # XXX: Only temporary and has to be version-specific
    src = source.plugins;

    phases = [ "unpackPhase" "patchPhase" "checkPhase" "installPhase" ];
    outputs = [ "pdf" "flash" ];

    unpackCmd = let
      chan = if source.channel == "dev"    then "chrome-unstable"
        else if source.channel == "stable" then "chrome"
        else "chrome-${source.channel}";
    in ''
      mkdir -p plugins
      ar p "$src" data.tar.lzma | tar xJ -C plugins --strip-components=4 \
        ./opt/google/${chan}/PepperFlash \
        ./opt/google/${chan}/libpdf.so
    '';

    doCheck = true;
    checkPhase = ''
      ! find -iname '*.so' -exec ldd {} + | grep 'not found'
    '';

    patchPhase = let
      rpaths = [ stdenv.gcc.gcc ];
      mkrpath = p: "${makeSearchPath "lib64" p}:${makeSearchPath "lib" p}";
    in ''
      for sofile in PepperFlash/libpepflashplayer.so libpdf.so; do
        chmod +x "$sofile"
        patchelf --set-rpath "${mkrpath rpaths}" "$sofile"
      done
    '';

    installPhase = let
      pdfName = "Chrome PDF Viewer";
      pdfDescription = "Portable Document Format";
      pdfMimeTypes = concatStringsSep ";" [
        "application/pdf"
        "application/x-google-chrome-print-preview-pdf"
      ];
      pdfInfo = "#${pdfName}#${pdfDescription};${pdfMimeTypes}";
    in ''
      install -vD libpdf.so "$pdf/lib/libpdf.so"
      mkdir -p "$pdf/nix-support"
      echo "--register-pepper-plugins='$pdf/lib/libpdf.so${pdfInfo}'" \
        > "$pdf/nix-support/chromium-flags"

      flashVersion="$(
        sed -n -r 's/.*"version": "([^"]+)",.*/\1/p' PepperFlash/manifest.json
      )"

      install -vD PepperFlash/libpepflashplayer.so \
        "$flash/lib/libpepflashplayer.so"
      mkdir -p "$flash/nix-support"
      echo "--ppapi-flash-path='$flash/lib/libpepflashplayer.so'" \
           "--ppapi-flash-version=$flashVersion" \
           > "$flash/nix-support/chromium-flags"
    '';

    passthru.flagsEnabled = let
      enabledPlugins = optional enablePepperFlash plugins.flash
                    ++ optional enablePepperPDF   plugins.pdf;
      getFlags = plugin: "$(< ${plugin}/nix-support/chromium-flags)";
    in concatStringsSep " " (map getFlags enabledPlugins);
  };
in plugins
