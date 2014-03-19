{ stdenv
, enablePepperFlash ? false
, enablePepperPDF ? false
, fetchurl # XXX
}:

with stdenv.lib;

let
  plugins = stdenv.mkDerivation {
    name = "chromium-binary-plugins";

    # XXX: Only temporary and has to be version-specific
    src = fetchurl {
      url = "https://dl.google.com/linux/chrome/deb/pool/main/g/"
          + "google-chrome-unstable/google-chrome-unstable_"
          + "35.0.1897.2-1_amd64.deb";
      sha1 = "b68683fc5321d10536e4135c266b14894b7668ed";
    };

    phases = [ "unpackPhase" "patchPhase" "checkPhase" "installPhase" ];
    outputs = [ "pdf" "flash" ];

    unpackCmd = ''
      ensureDir plugins
      ar p "$src" data.tar.lzma | tar xJ -C plugins --strip-components=4 \
        ./opt/google/chrome-unstable/PepperFlash \
        ./opt/google/chrome-unstable/libpdf.so
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
      ensureDir "$pdf/nix-support"
      echo "--register-pepper-plugins='$pdf/lib/libpdf.so${pdfInfo}'" \
        > "$pdf/nix-support/chromium-flags"

      flashVersion="$(
        sed -n -r 's/.*"version": "([^"]+)",.*/\1/p' PepperFlash/manifest.json
      )"

      install -vD PepperFlash/libpepflashplayer.so \
        "$flash/lib/libpepflashplayer.so"
      ensureDir "$flash/nix-support"
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
