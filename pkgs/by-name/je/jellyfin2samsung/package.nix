{
  lib,
  stdenv,
  fetchurl,
  runCommand,
  buildFHSEnv,
  writeShellScript,
  copyDesktopItems,
  makeDesktopItem,
  krb5,
  openssl,
  icu,
  zlib,
  fontconfig,
  freetype,
  nmap,
  curl,
  wget,
  # Kept as nullable: in some cross-eval contexts callPackage hands us a
  # pkgs set where these are missing/null. The `isSupported` check below
  # routes us to the stub in that case instead of letting the FHS env
  # below crash trying to dereference a null `xorg`.
  libgcc ? null,
  libGL ? null,
  xorg ? null,
  iproute2 ? null,
}:

let
  pname = "jellyfin2samsung";
  version = "2.2.1.0";

  meta = {
    description = "One-click Jellyfin installer for Samsung Tizen Smart TVs";
    homepage = "https://github.com/Jellyfin2Samsung/Samsung-Jellyfin-Installer";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "Jellyfin2Samsung";
    maintainers = with lib.maintainers; [
      confused-engineer
    ];
  };

  # The nixpkgs CI evaluates this package through `release-lib.nix` /
  # `pkgsForCross` on combinations beyond what `meta.platforms` filters.
  # In some of those combinations `pkgs.xorg` (and friends) come in as
  # `null` even though `stdenv.hostPlatform.system` is still
  # "x86_64-linux". If we proceeded, the FHS env below would force
  # `xorg.libX11` and fail eval with "expected a set but found null".
  # So gate on both the platform *and* the actual deps being present.
  isSupported =
    stdenv.hostPlatform.system == "x86_64-linux"
    && xorg != null
    && libGL != null
    && libgcc != null
    && iproute2 != null;
in

if !isSupported then
  # Stub that evaluates fine on every system/cross-context the CI throws
  # at us, but refuses to actually build anywhere except x86_64-linux.
  stdenv.mkDerivation {
    inherit pname version meta;
    dontUnpack = true;
    dontBuild = true;
    installPhase = ''
      echo "jellyfin2samsung is only supported on x86_64-linux." >&2
      exit 1
    '';
  }
else

  let
    src = fetchurl {
      url = "https://github.com/Jellyfin2Samsung/Samsung-Jellyfin-Installer/releases/download/v${version}/Jellyfin2Samsung-v${version}-linux-x64.tar.gz";
      # sha256 from the GitHub-generated release page
      sha256 = "b8232903ee3c402c00f68bc90bacff4b87287004c1b92a068863a5f1f66b01cb";
    };

    krb5WithUnversionedLib = runCommand "krb5-unversioned-so" { } ''
      mkdir -p $out/lib
      ln -s ${krb5}/lib/libgssapi_krb5.so.2 $out/lib/libgssapi_krb5.so
    '';

    # Unwrap the tarball into a derivation
    jellyfin2samsung-unwrapped = stdenv.mkDerivation {
      pname = "${pname}-unwrapped";
      inherit version src;

      # The tarball might not have a top-level directory
      sourceRoot = ".";

      # FHS env provides all libraries at runtime
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
    fhs = buildFHSEnv {
      name = "Jellyfin2Samsung";

      targetPkgs = _: [
        # ── core .NET runtime ────────────────────────────────────────────────
        stdenv.cc.cc.lib
        openssl
        icu
        zlib
        krb5
        krb5WithUnversionedLib

        # ── Skia / font rendering ────────────────────────────────────────────
        fontconfig
        freetype
        libGL

        # ── X11 / Avalonia backend ───────────────────────────────────────────
        xorg.libX11
        xorg.libICE
        xorg.libSM
        xorg.libXext
        xorg.libXcursor
        xorg.libXi
        xorg.libXrandr
        xorg.libXrender
        xorg.libXinerama
        xorg.libXcomposite
        xorg.libXdamage
        xorg.libXfixes
        xorg.libXtst

        # ── networking / utilities used by the app ───────────────────────────
        nmap
        iproute2
        curl
        wget
      ];

      runScript = writeShellScript "jellyfin2samsung-run" ''
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
    };

  in
  stdenv.mkDerivation {
    inherit pname version meta;

    strictDeps = true;
    __structuredAttrs = true;

    dontUnpack = true;
    dontBuild = true;

    nativeBuildInputs = [ copyDesktopItems ];

    desktopItems = [
      (makeDesktopItem {
        name = "jellyfin2samsung";
        desktopName = "Jellyfin2Samsung";
        comment = "Install Jellyfin on your Samsung Smart TV";
        exec = "Jellyfin2Samsung";
        icon = "jellyfin2samsung";
        terminal = false;
        type = "Application";
        categories = [
          "Utility"
          "Network"
        ];
        keywords = [
          "jellyfin"
          "samsung"
          "tizen"
          "tv"
        ];
        startupWMClass = "Jellyfin2Samsung";
      })
    ];

    installPhase = ''
      runHook preInstall

      # Symlink the FHS-wrapped binary
      mkdir -p $out/bin
      ln -s ${fhs}/bin/Jellyfin2Samsung $out/bin/Jellyfin2Samsung

      # Desktop icon
      mkdir -p $out/share/icons/hicolor/256x256/apps
      cp ${jellyfin2samsung-unwrapped}/lib/jellyfin2samsung/Assets/jelly2sams.png \
          $out/share/icons/hicolor/256x256/apps/jellyfin2samsung.png

      runHook postInstall
    '';
  }
