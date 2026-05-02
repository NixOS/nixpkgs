{ pkgs ? import <nixpkgs> {} }:

let
  # Update this to match the release version you want
  version = "2.2.0.7";

  src = pkgs.fetchurl {
    url = "https://github.com/Jellyfin2Samsung/Samsung-Jellyfin-Installer/releases/download/v${version}/Jellyfin2Samsung-v${version}-linux-x64.tar.gz";
    # IMPORTANT: You must replace this hash the first time you build.
    # Run:  nix-prefetch-url --unpack <url>
    # or just set it to "" and let the build error tell you the correct hash.
    sha256 = "/Rt4aGopd/nuj7jQRzBH/xWnib2QMdobY3UmQAOWgQc=";
  };

  krb5WithUnversionedLib = pkgs.runCommand "krb5-unversioned-so" {} ''
    mkdir -p $out/lib
    ln -s ${pkgs.krb5}/lib/libgssapi_krb5.so.2 $out/lib/libgssapi_krb5.so
  '';

  # Unwrap the tarball into a derivation
  jellyfin2samsung-unwrapped = pkgs.stdenv.mkDerivation {
    pname = "jellyfin2samsung-unwrapped";
    inherit version src;

    # The tarball might not have a top-level directory
    sourceRoot = ".";

    # No patching needed — the FHS env provides all libraries at runtime
    dontBuild = true;
    dontConfigure = true;
    dontPatchELF = true;
    dontStrip = true;
    dontFixup = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/jellyfin2samsung

      # Handle both cases: tarball with top-level dir or flat files
      if [ -f Jellyfin2Samsung ]; then
        cp -r . $out/lib/jellyfin2samsung/
      elif [ -d Jellyfin2Samsung-linux-x64 ]; then
        cp -r Jellyfin2Samsung-linux-x64/* $out/lib/jellyfin2samsung/
      else
        # Find wherever the main binary ended up
        find . -name 'Jellyfin2Samsung' -type f | head -1 | xargs -I{} dirname {} | xargs -I{} cp -r {}/* $out/lib/jellyfin2samsung/
      fi

      chmod +x $out/lib/jellyfin2samsung/Jellyfin2Samsung || true

      runHook postInstall
    '';
  };

  # FHS environment so all dynamically linked binaries (TizenSdb, .NET native
  # libs, etc.) work without patching
  fhs = pkgs.buildFHSEnv {
    name = "Jellyfin2Samsung";

    targetPkgs = p: with p; [
      # ── core .NET runtime ──────────────────────────────────────────────────
      stdenv.cc.cc.lib
      openssl
      icu
      zlib
      libgcc.lib
      krb5
      krb5WithUnversionedLib

      # ── Skia / font rendering ─────────────────────────────────────────────
      fontconfig
      freetype
      libGL

      # ── X11 / Avalonia backend ─────────────────────────────────────────────
      libX11
      libICE
      libSM
      libXext
      libXcursor
      libXi
      libXrandr
      libXrender
      libXinerama
      libXcomposite
      libXdamage
      libXfixes
      libXtst

      # ── networking / utilities used by the app ─────────────────────────────
      nmap
      iproute2
      curl
      wget
    ];

    runScript = pkgs.writeShellScript "jellyfin2samsung-run" ''
      # The app writes Logs/, Assets/, certs, etc. next to its own binary.
      # The Nix store is read-only, so we maintain a writable copy in the
      # user's home directory and sync new versions automatically.
      APP_DIR="$HOME/.local/share/jellyfin2samsung"
      STAMP="$APP_DIR/.nix-version"
      CURRENT="${jellyfin2samsung-unwrapped}"

      # (Re)create the writable copy when the Nix store path changes (i.e. upgrade)
      if [ ! -f "$STAMP" ] || [ "$(cat "$STAMP")" != "$CURRENT" ]; then
        echo "Setting up Jellyfin2Samsung in $APP_DIR ..."

        # Back up user data dirs if they exist
        TMPBACK="$(mktemp -d)"
        for d in Logs Certs Settings; do
          if [ -d "$APP_DIR/$d" ]; then
            mv "$APP_DIR/$d" "$TMPBACK/$d"
          fi
        done

        # Clean and recreate
        rm -rf "$APP_DIR"
        mkdir -p "$APP_DIR"

        # Copy fresh app files
        cp -r ${jellyfin2samsung-unwrapped}/lib/jellyfin2samsung/* "$APP_DIR/"
        chmod -R u+w "$APP_DIR"

        # Restore user data
        for d in Logs Certs Settings; do
          if [ -d "$TMPBACK/$d" ]; then
            rm -rf "$APP_DIR/$d"
            mv "$TMPBACK/$d" "$APP_DIR/$d"
          fi
        done
        rm -rf "$TMPBACK"

        echo "$CURRENT" > "$STAMP"
      fi

      cd "$APP_DIR"
      exec ./Jellyfin2Samsung "$@"
    '';

    meta = with pkgs.lib; {
      description = "One-click Jellyfin installer for Samsung Tizen Smart TVs";
      homepage = "https://github.com/Jellyfin2Samsung/Samsung-Jellyfin-Installer";
      license = licenses.mit;
      platforms = [ "x86_64-linux" ];
      mainProgram = "Jellyfin2Samsung";
    };
  };

in
pkgs.stdenv.mkDerivation {
  pname = "Jellyfin2Samsung";
  inherit version;

  # No source needed — we just wrap the FHS env and add desktop integration
  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [ pkgs.copyDesktopItems ];

  installPhase = ''
    runHook preInstall

    # Symlink the FHS-wrapped binary
    mkdir -p $out/bin
    ln -s ${fhs}/bin/Jellyfin2Samsung $out/bin/Jellyfin2Samsung

    # Desktop Icon
    mkdir -p $out/share/icons/hicolor/256x256/apps
    cp ${jellyfin2samsung-unwrapped}/lib/jellyfin2samsung/Assets/jelly2sams.png \
        $out/share/icons/hicolor/256x256/apps/jellyfin2samsung.png

    # Desktop entry for app launchers
    mkdir -p $out/share/applications
    cat > $out/share/applications/jellyfin2samsung.desktop <<EOF
[Desktop Entry]
Name=Jellyfin2Samsung
Comment=Install Jellyfin on your Samsung Smart TV
Exec=$out/bin/Jellyfin2Samsung
Icon=$out/share/icons/hicolor/256x256/apps/jellyfin2samsung.png
Terminal=false
Type=Application
Categories=Utility;Network;
Keywords=jellyfin;samsung;tizen;tv;
StartupWMClass=Jellyfin2Samsung
EOF

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "One-click Jellyfin installer for Samsung Tizen Smart TVs";
    homepage = "https://github.com/Jellyfin2Samsung/Samsung-Jellyfin-Installer";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "Jellyfin2Samsung";
    maintainers = with lib.maintainers; [
      PatrickSt1991
      Confused-Engineer
    ];
  };
}
