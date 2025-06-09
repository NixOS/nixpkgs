{
  lib,
  stdenv,
  fetchurl,
  subversion,
  fetchsvn,
  fetchzip,
  pkg-config,
  zlib,
  zstd,
  libpng,
  bzip2,
  SDL2,
  SDL2_mixer,
  fontconfig,
  miniupnpc,
  symlinkJoin,
  makeWrapper,
  runCommand,
  cabextract,
}:
let
  fetchcab =
    args:
    runCommand "source-cab" { nativeBuildInputs = [ cabextract ]; } ''
      cabextract ${fetchurl args} -d $out
    '';

  fetchzip' = defaults: args: fetchzip (defaults // args);

  # it is okay if this is unused. keep it around for future use.
  fetch-svn-patch =
    {
      rev,
      repo ? "simutrans",
      url ? "svn://servers.simutrans.org",
      hash,
    }:
    let
      prev = toString (rev - 1);
      this = toString rev;

      name = "${repo}-r${this}.patch";

      raw =
        runCommand name
          {
            nativeBuildInputs = [ subversion ];
            outputHashMode = "recursive";
            outputHash = hash;
          }
          ''
            svn diff --git ${
              lib.escapeShellArgs [
                "${url}@${prev}"
                "${url}@${this}"
              ]
            } > $out
          '';
    in
    # this is necessary to make the patch git-compatible
    runCommand name { } ''
      substitute ${raw} $out \
        --replace-fail "${repo}/trunk/" ""
    '';

  version = "124.3.1";

  src = fetchsvn {
    url = "svn://servers.simutrans.org/simutrans";
    # The rev can be found in the forum thread for the release: https://forum.simutrans.com/index.php/board,3.0.html
    rev = "11671";
    hash = "sha256-Ya5R7Z7dZQtA5kURBNdRZD4v8gB3WpNK01jpZMEn5ss=";
  };

  # There are several sources of paksets.
  # - The AUR is mostly maintained by Roboron, who is part of the Simutrans team and in charge of Steam releases.
  #   https://aur.archlinux.org/packages?K=simutrans-pak
  # - The forum lists some paksets, but it's not very comprehensive
  #   https://forum.simutrans.com/index.php/board,3.0.html
  # - The actual in-game pakset selection menu is from the `get_pak.sh` script. This link goes to a generated header file.
  #   https://github.com/simutrans/simutrans/blob/master/src/paksetinfo.h
  # - The official site lists many paksets. It has the most consistent naming scheme.
  #   https://www.simutrans.com/en/paksets/
  # In general, the official site should be used for naming (e.g. pakHD, pakHAJO),
  # all the pakNames here should be of form pakXX.name where XX is the size,
  # and it should include everything from `paksetinfo.h` because otherwise the game would offer additional downloads.
  pakSpec =
    lib.mapAttrs
      (
        pakName:
        {
          prefix ? "",
          hash ? lib.fakeHash,

          fetcher ? fetchzip,

          basePath ? pakName,
          srcPath ? throw "srcPath is required",

          url ? "mirror://sourceforge/simutrans/${
            builtins.concatStringsSep "/" (map lib.escapeURL ([ basePath ] ++ srcPath))
          }",

          # This debug option is useful for adding new paksets.
          # Add the URL, and set { inspect = true; hash = lib.fakeHash; }
          # Then, fix the hash, and keep fixing `prefix` until it shows `.pak` files.
          # Then you can remove `inspect` and it should work.
          inspect ? false,
        }:
        mkPak {
          inherit pakName prefix inspect;
          src = fetcher { inherit url hash; };
        }
      )
      {
        "pak32.comic" = {
          srcPath = [
            "pak32.comic for 102-0"
            "pak32.comic_102-0.zip"
          ];
          prefix = "/pak32";
          hash = "sha256-xDcUtRAw6GXvI9YJAtBfNauL2QVsIl1Bh4cU10bEbTQ=";
        };

        "pak48.excentrique" = {
          url = "https://github.com/Varkalandar/pak48.Excentrique/releases/download/v0.19_RC3/pak48.excentrique_v019rc3.zip";
          hash = "sha256-vlAMRP+gaKspDuEkrpRcc+UdL+5d3rX9uWIMowr1yw8=";
        };
        "pak48.bitlit" = {
          fetcher = fetchzip' { stripRoot = false; };
          url = "https://codeberg.org/Nazalassa/pak48.bitlit/releases/download/0.1d/pak48.bitlit_0.1d.zip";
          prefix = "/pak48.bitlit";
          hash = "sha256-pk8aB5YZHFgJh5diaUUpp9hAoBJ5Y+T9wQSw25evnA0=";
        };

        pak64 = {
          srcPath = [
            "124-3"
            "simupak64-124-3.zip"
          ];
          prefix = "/pak";
          hash = "sha256-mtxZ5i33O0gYbH4TRDqKGclRs0QnMuhws7Ic4bSGKac=";
        };
        "pak64.classic" = {
          basePath = "pakHAJO";
          srcPath = [
            "pakHAJO_102-2-2"
            "pakHAJO_0-102-2-2.zip"
          ];
          prefix = "/pakHAJO";
          hash = "sha256-Sr5WszHzCcWAjLWc+xX5kDhAMrqpw/HertiMLpNafNM=";
        };
        "pak64.contrast" = {
          srcPath = [ "pak64.Contrast_910.zip" ];
          hash = "sha256-pacX91SOCqIRRNr9yfroMJQX2Zw+S5sK/Wfz7lzUupQ=";
        };
        "pak64.german" = {
          url = "https://simutrans-germany.com/pak.german/pak64.german_0-124-0-0-5_full.zip";
          prefix = "/pak64.german";
          hash = "sha256-maeevTsrSi8zwM44xo7kgVA1fqBBrqH0iM52wQDROc4=";
        };
        "pak64.ho-scale" = {
          url = "http://simutrans.bilkinfo.de/pak64.ho-scale-latest.tar.gz";
          hash = "sha256-N4LYhmRx+8xj8zOJ0gf0flpqYyIXgCSkKjoLkIdbOU0=";
        };
        "pak64.japan" = {
          srcPath = [
            "123-0"
            "simupak64.japan-123-0.zip"
          ];
          prefix = "/pak.japan";
          hash = "sha256-OcKdDkkmpV1LH7VUsgKy88V1KfzkV09Ti0cmxKLv0ic=";
        };
        "pak64.nippon" = {
          url = "https://github.com/wa-st/pak-nippon/releases/download/v0.6.2/pak.nippon-v0.6.2.zip";
          hash = "sha256-mw6tYFU5v6ezZoMGHhrtqMtGNDU2Jn1VKID2mzklui0=";
        };
        "pak64.scifi" = {
          srcPath = [ "pak64.scifi_112.x_v0.2.zip" ];
          prefix = "/pak64.scifi";
          hash = "sha256-Itm8O8OGpGvQPAPJYWniycDWRI9m93Wm4iWUOwPWNio=";
        };
        "pak64.ttd" = {
          basePath = "pakTTD";
          srcPath = [ "simupakTTD-124-0.zip" ];
          prefix = "/pakTTD";
          hash = "sha256-oi2V6FuXgwcd57hIR2I21IWz2n+qc39WpOYMFmuPOdA=";
        };

        "pak96.comic" = {
          srcPath = [
            "pak96.comic for 111-3"
            "pak96.comic-0.4.10-plus.zip"
          ];
          prefix = "/pak96.comic";
          hash = "sha256-F1/1m4tNZKRxZMD9POrUj+HSnx9oSzr0cdssGifC3NM=";
        };
        "pak96.hd" = {
          basePath = "OldFiles";
          srcPath = [ "PakHD_v04B_100-0.zip" ];
          prefix = "/pakHD";
          hash = "sha256-w2Yx4+embGf0AInTErA7Rna+oq0OxYFihrAWJ3GM1Eg=";
        };

        pak128 = {
          srcPath = [
            "pak128 for ST 124.3up (2.10.0)"
            "simupak128-2-10-for124-3up.zip"
          ];
          prefix = "/pak128";
          hash = "sha256-MC1NR5vUMq+59Irxya9PXPh5kh0lpXhnuwKH7cA+jUM=";
        };
        "pak128.britain" = {
          srcPath = [
            "pak128.Britain for 120-3"
            "pak128.Britain.1.18-120-3.zip"
          ];
          prefix = "/pak128.Britain";
          hash = "sha256-h0oKqq75H0PJOZJO+Y8k1TSFUmczwqNk6VQiHemDznU=";
        };
        "pak128.cs" = {
          basePath = "Pak128.CS";
          # I'm not sure why this is in "nightly builds",
          # but it's still referenced in 124.3.1, so it's gotta be compatible.
          srcPath = [
            "nightly builds"
            "pak128.CS-r2096.zip"
          ];
          hash = "sha256-vQ8HZqwICB3CUGQW8NwEWGVA3anUbCOdj3BEV3lLLpk=";
        };
        "pak128.german" = {
          url = "https://pak128-german.de/PAK128.german_2.3_beta.zip";
          prefix = "/PAK128.german";
          hash = "sha256-anWImSrS5ayjYzqVV7MY2VZ4dD/jLkhaavcZaufre+k=";
        };
        "pak128.japan" = {
          fetcher = fetchcab;
          url = "http://pak128.jpn.org/souko/pak128.japan.120.0.cab";
          prefix = "/pak128.japan";
          hash = "sha256-dJOpYVdh55mHm3kCKBwlShl3+6I/TRBAkD7ivoFI1HI=";
        };

        "pak144.excentrique" = {
          url = "https://github.com/Varkalandar/pak144.Excentrique/releases/download/r0.08/pak144.Excentrique_v008.zip";
          hash = "sha256-Iqe6enB3AD8BgaLshwTHjv61xfp9OMaoLwkfDakr53I=";
        };

        "pak192.comic" = {
          url = "https://github.com/Flemmbrav/Pak192.Comic/releases/download/V0.7.2/pak192.comic-serverset.zip";
          hash = "sha256-SnuB39iUIJLO9wWK7gT/OQTH0oV7rjp8bUOvZx9+rkQ=";
        };
      };

  mkPak =
    {
      pakName,
      prefix,
      src,
      inspect,
    }:
    runCommand "simutrans-${pakName}" { preferLocalBuild = true; } ''
      mkdir -p $out/share/simutrans/${pakName}
      ${lib.optionalString inspect ''
        ls ${src}${prefix}
        exit 1
      ''}
      cp -r ${src}${prefix}/* $out/share/simutrans/${pakName}
    '';

  withPaks =
    paks:
    symlinkJoin {
      pname = "simutrans";
      inherit version;

      paths = [ simutrans-bin ] ++ paks;
      nativeBuildInputs = [ makeWrapper ];
      # The game has three directories it reads data from:
      #
      # - The "base" directory, which is the directory containing resources included in the package.
      #   This will be in the nix store, and is read-only. In our case, it's $out/share/simutrans.
      #
      # - The "user" directory, which is the directory containing user data.
      #   This must be writable; it's in the user's home directory. It's where the game saves games, settings, etc.
      #
      # - The "install" directory, which also must be writable.
      #   This is where the in-game pakset installer downloads to.
      #
      # The base directory is special, it is specified with '-set_basedir' or argv[0].
      # The argv0 value will be $out/bin/simutrans, which contains no resources. We set it with '-set_basedir'.
      #
      # The user and install directories are more similar, and can be set with '-set_userdir' and '-set_installdir'.
      # However, the user might reasonably want to set these directories manually.
      # So, we set them with environment variables, and the game will use them if they are set.
      # The game reads from $SIMUTRANS_USERDIR and $SIMUTRANS_INSTALLDIR.
      # There is no equivalent environment variable for the base directory. (argv[0] i guess)
      #
      # By default, the game will respect $XDG_DATA_HOME and place its files in $XDG_DATA_HOME/simutrans.
      # If $XDG_DATA_DIR is not set, it will break the XDG spec and place its files in ~/simutrans.
      # The XDG spec says that the default should be ~/.local/share/simutrans in that case.
      # (that is, the default value for the "user" directory is ${XDG_DATA_HOME:-$HOME}/simutrans)
      #
      # The value for the "user" directory is the first of these that is valid:
      # - '-set_userdir' command line argument
      # - $SIMUTRANS_USERDIR
      # - $XDG_DATA_HOME/simutrans
      # - ~/simutrans
      #
      # The default value for the "install" directory is the "user" directory with /paksets appended.
      # Its user-settable parameters are analogous to the "user" directory.
      #
      # Prior to version 124.0, none of this was applicable. The game only ever used ~/simutrans and $PWD.
      # The previous versions of this package in nixpkgs would patch the game to use ~/.simutrans instead.
      #
      # For backwards compatibility, it is desirable to default to ~/.simutrans still, if it already exists,
      # but prefer using $XDG_DATA_HOME/simutrans in all other cases. That is what `default-home` is for.
      # It will be set to ~/.simutrans if and only if it exists, otherwise it will be set to "${XDG_DATA_HOME:-$HOME/.local/share}/simutrans".
      # That is, we intentionally follow the XDG basedir spec, and **override the default behaviour of the executable here**,
      # which, again, wouldn't normally follow the XDG basedir spec. It normally wants "${XDG_DATA_HOME:-$HOME}/simutrans" (which we override)
      #
      # Then, we use it to set defaults for SIMUTRANS_USERDIR and SIMUTRANS_INSTALLDIR.
      # These should be '--set-default's, but wrapProgram will only accept literal strings here.
      # We're reading from the environment, so we use --run instead.
      #
      # A user can overwrite these values:
      # - Setting SIMUTRANS_USERDIR and SIMUTRANS_INSTALLDIR in the environment will take priority over these defaults.
      # - Setting SIMUTRANS_USERDIR and SIMUTRANS_INSTALLDIR to empty strings will disable them.
      # - Passing '-set_userdir' and '-set_installdir' to the game will take priority over the environment variables.
      postBuild =
        let
          default-home = ''$(if [ -d "$HOME/.simutrans" ]; then echo "$HOME/.simutrans"; else echo "''${XDG_DATA_HOME:-$HOME/.local/share}/simutrans"; fi)'';
        in
        ''
          wrapProgram $out/bin/simutrans \
            --run 'export SIMUTRANS_USERDIR=''${SIMUTRANS_USERDIR-${default-home}}' \
            --run 'export SIMUTRANS_INSTALLDIR=''${SIMUTRANS_INSTALLDIR-${default-home}/paksets}' \
            --add-flags "-set_basedir $out/share/simutrans"

          mkdir -p $out/share/{applications,icons/hicolor/scalable/apps}

          cp ${src}/trunk/src/simutrans/simutrans.svg $out/share/icons/hicolor/scalable/apps/simutrans.svg
          cp ${src}/trunk/src/linux/simutrans.desktop $out/share/applications/simutrans.desktop
        '';

      strip = false;

      passthru.bin = simutrans-bin;
      passthru.pakSpec = pakSpec;

      meta = simutrans-bin.meta // {
        hydraPlatforms = [ ];

        # re-setting this for clarity, because there is a semantic difference
        sourceProvenance = [
          # Here, we obviously have the source code of the game,
          # BUT we also include the paksets, which can contain Squirrel scripts.
          #
          # This language allows compilation to bytecode, but Simutrans does not do that.
          # The paksets all contain Squirrel source code, which is compiled at runtime.
          # You can prove this to yourself by running this command:
          #
          #     fd '\.nut$' $(nix build --print-out-paths --no-link .#simutrans)
          #
          # And looking at any of these files will show you that they are source files.
          # So, they also have a source provenance of `fromSource`.
          lib.sourceTypes.fromSource
        ];
      };
    };

  simutrans-bin = stdenv.mkDerivation {
    pname = "simutrans-bin";
    inherit version src;

    sourceRoot = "simutrans-r${src.rev}/trunk";

    # We always build from the stable revision, but we may need to apply some patches.
    #
    # Use `fetch-svn-patch` to get the patches if they are merged upstream.
    #
    #     fetch-svn-patch {
    #       rev = 11174; # or whatever revision we need
    #       hash = lib.fakeHash; # replace with the actual hash
    #     }
    #
    # And if they aren't merged upstream, fetch them from wherever else or vendor next to this file.
    #
    # We do *not* ever build a newer revision, because multiplayer compatibility depends on the revision number.
    patches = [
      # currently, no patches are needed.
    ];

    nativeBuildInputs = [ pkg-config ];
    buildInputs = [
      zlib
      zstd
      libpng
      bzip2
      SDL2
      SDL2_mixer
      fontconfig
      miniupnpc
    ];

    # https://simutrans-germany.com/wiki/wiki/en_CompilingSimutrans#Manual_configuration_with_make
    configuration =
      let
        platform =
          if stdenv.hostPlatform.isLinux then
            "linux"
          else if stdenv.hostPlatform.isDarwin then
            "mac"
          else
            throw "add your platform";
      in
      ''
        BACKEND := sdl2
        OSTYPE := ${platform}

        OPTIMISE := 1
        MSG_LEVEL := 3

        MULTI_THREAD := 1

        USE_UPNP := 1
        USE_ZSTD := 1
        USE_FREETYPE := 1
        USE_FONTCONFIG := 1
        USE_FLUIDSYNTH_MIDI := 1

        FLAGS := -DREVISION=${src.rev}
      '';

    passAsFile = [ "configuration" ];

    configurePhase = ''
      cp $configurationPath config.default
    '';

    enableParallelBuilding = true;

    installPhase = ''
      mkdir -p $out/{bin,share}
      mv simutrans $out/share/simutrans
      mv build/default/sim $out/bin/simutrans
    '';

    strip = false;

    meta = {
      description = "Simulation game in which the player strives to run a successful transport system";
      mainProgram = "simutrans";
      longDescription = ''
        Simutrans is a cross-platform simulation game in which the
        player strives to run a successful transport system by
        transporting goods, passengers, and mail between
        places. Simutrans is an open source remake of Transport Tycoon.
      '';

      homepage = "https://www.simutrans.com/";
      license = with lib.licenses; [
        artistic1
        gpl1Plus
      ];
      maintainers = with lib.maintainers; [
        sodiboo
        Makuru
      ];
      platforms = lib.platforms.linux; # TODO: ++ darwin;
      sourceProvenance = [
        lib.sourceTypes.fromSource
      ];
    };
  };
in
lib.makeOverridable ({ paks }: withPaks paks) {
  paks = lib.attrValues pakSpec;
}
