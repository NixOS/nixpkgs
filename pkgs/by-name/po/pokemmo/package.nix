{
  alsa-lib,
  autoPatchelfHook,
  copyDesktopItems,
  dbus,
  fetchurl,
  gccForLibs,
  glib,
  gtk4,
  lib,
  libGL,
  libdecor,
  libdrm,
  libx11,
  libxcursor,
  libxext,
  libxfixes,
  libxi,
  libxkbcommon,
  libxrandr,
  libxscrnsaver,
  libxtst,
  libz,
  makeDesktopItem,
  makeWrapper,
  mesa,
  stdenvNoCC,
  undmg,
  unzip,
  wayland,
}:

let
  gtk = gtk4;
  launcherVersion = "62";
in
stdenvNoCC.mkDerivation (
  finalAttrs:
  {
    pname = "pokemmo";
    version = "32920"; # https://dl.pokemmo.com/live/current/revision.txt
    __structuredAttrs = true;
    strictDeps = true;

    src =
      if stdenvNoCC.hostPlatform.isDarwin then
        fetchurl {
          url = "https://dl.pokemmo.com/PokeMMO-v${launcherVersion}.dmg";
          hash = "sha256-2YUvrV2xaMJiJ3KaefIV/4PRj0b+5KRu5T4Y7bycj5s=";
        }
      else
        fetchurl {
          url = "https://dl.pokemmo.com/PokeMMO-Client.zip?r=${finalAttrs.version}";
          hash = "sha256-eFJBIDbpawkRL2Zr3HE41+YY0bqvVCUqzQr0cdj2xM4=";
        };

    desktopItems = [
      (makeDesktopItem (
        with finalAttrs;
        {
          name = "pokemmo";
          desktopName = "PokeMMO";
          exec = meta.mainProgram;
          icon = "pokemmo";
          comment = meta.description;
          categories = [
            "Game"
            "RolePlaying"
          ];
        }
      ))
    ];

    passthru.updateScript = ./update.sh;

    meta = {
      description = "Free-to-play MMORPG";
      longDescription = ''
        Multiplayer online Pokémon game spanning Kanto, Johto, Hoenn,
        Sinnoh and Unova.  PokeMMO does **NOT** distribute ROMs, and
        the client requires importing your own copies of the supported
        Pokémon ROMs at least once via the Client Management screen.
        Game data and save files live in `$XDG_DATA_HOME/pokemmo`.
      '';
      homepage = "https://pokemmo.com";
      license = lib.licenses.unfree;
      platforms = lib.platforms.darwin ++ [
        "aarch64-linux"
        "x86_64-linux"
      ];
      mainProgram = "PokeMMO";
      maintainers = with lib.maintainers; [ yiyu ];
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    };
  }
  // (
    if stdenvNoCC.hostPlatform.isDarwin then
      {
        sourceRoot = "PokeMMO.app";

        nativeBuildInputs = [ undmg ];

        installPhase = ''
          runHook preInstall

          mkdir --parents "$out"/Applications
          cp --recursive Contents "$out"/Applications

          runHook postInstall
        '';
      }
    else
      {
        nativeBuildInputs = [
          autoPatchelfHook
          copyDesktopItems
          unzip
          makeWrapper
        ];

        buildInputs = [ libz ];

        unpackCmd = "unzip \"$curSrc\"";
        sourceRoot = ".";

        installPhase =
          let
            # The client uses its working directory as "Client Home"
            # and needs it writable (config/, log/, data/mods/).
            # Symlink the read-only game data from the store into a
            # per-user directory, keeping data/mods writable (it is
            # recreated on game updates).
            setupClientHome = ''
              POKEMMO_HOME="''${XDG_DATA_HOME:-$HOME/.local/share}/pokemmo"
              mkdir --parents "$POKEMMO_HOME"

              if [ ! -f "$POKEMMO_HOME/.data-path" ] || \
                [ "$(cat "$POKEMMO_HOME/.data-path")" \
                  != "$POKEMMO_DATA" ]; then
                rm -rf "$POKEMMO_HOME/data"
                mkdir --parents "$POKEMMO_HOME/data/mods"
                for entry in "$POKEMMO_DATA"/data/*; do
                  name=$(basename "$entry")
                  [ "$name" = mods ] ||
                    ln --symbolic "$entry" "$POKEMMO_HOME/data/$name"
                done
                printf '%s\n' "$POKEMMO_DATA" >"$POKEMMO_HOME/.data-path"
              fi

              cd "$POKEMMO_HOME" || exit
            '';
          in
          ''
            runHook preInstall

            install -D \
              bin/linux/${if stdenvNoCC.hostPlatform.isAarch64 then "arm64" else "x64"}/* \
              --target-directory="$out"/bin

            for size in 16 32 128; do
              install -Dm644 data/icons/"$size"x"$size".png \
                "$out"/share/icons/hicolor/"$size"x"$size"/apps/pokemmo.png
            done

            mkdir "$out"/share/pokemmo
            cp --recursive data "$_"

            wrapProgram "$out"/bin/PokeMMO \
              --set POKEMMO_DATA "$out"/share/pokemmo \
              --run '${setupClientHome}' \
              --set-default \
              EGL_VENDOR_LIBRARY_DIRS "${mesa}/share/glvnd/egl_vendor.d" \
              --set-default \
              GSETTINGS_SCHEMA_DIR "${gtk}/share/gsettings-schemas/${gtk.name}/glib-2.0/schemas" \
              --prefix LD_LIBRARY_PATH : "${
                lib.makeLibraryPath [
                  alsa-lib
                  dbus
                  gccForLibs
                  glib
                  gtk
                  libGL
                  libdecor
                  libdrm
                  libx11
                  libxcursor
                  libxext
                  libxfixes
                  libxi
                  libxkbcommon
                  libxrandr
                  libxscrnsaver
                  libxtst
                  mesa
                  wayland
                ]
              }"

            runHook postInstall
          '';
      }
  )
)
