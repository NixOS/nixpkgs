{
  lib,
  stdenv,
  fetchurl,
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

  version = "124.0";

  src = fetchsvn {
    url = "svn://servers.simutrans.org/simutrans";
    # The rev can be found in the forum thread for the release: https://forum.simutrans.com/index.php/board,3.0.html
    rev = "11164";
    hash = "sha256-+9dPnuy894qHzj7jNTfWC6Hl/QGKVgBCdmIAP9BKD+Q=";
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

        pak64 = {
          srcPath = [
            "124-0"
            "simupak64-124-0.zip"
          ];
          prefix = "/pak";
          hash = "sha256-jnEjsHjABxq/cyNOTAgES7SxDKjLfEeNhXzh5tchDsU=";
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
          url = "https://simutrans-germany.com/pak.german/pak64.german_0-124-0-0-2_full.zip";
          prefix = "/pak64.german";
          hash = "sha256-EMT4IqvsoG1FYvvWUcqR7sur0ERDfApC/iVEJKp3Prw=";
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
          fetcher = fetchzip' { stripRoot = false; };
          url = "https://hd.simutrans.com/release/PakHD_v04B_100-0.zip";
          prefix = "/pakHD";
          hash = "sha256-+/DZqRpYXEglM/NFAdGZR0TO9+aYTFhDMB5+9NEJeRk=";
        };

        pak128 = {
          srcPath = [
            "pak128 for ST 124up (2.9)"
            "simupak128-2.9-for124.zip"
          ];
          prefix = "/pak128";
          hash = "sha256-qjgnlIz7aQ73W7gFJpqBiE8BXabSrVgHwWVQotGwseE=";
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
          # This one is called "nightly builds" on the official site.
          # It's referenced in the game version 124.0, and it was last updated in 2021.
          # So, despite the name, it is compatible with the stable game (124.0 is from 2024)
          srcPath = [
            "nightly builds"
            "pak128.CS-r2096.zip"
          ];
          hash = "sha256-vQ8HZqwICB3CUGQW8NwEWGVA3anUbCOdj3BEV3lLLpk=";
        };
        "pak128.german" = {
          basePath = "PAK128.german";
          srcPath = [
            "PAK128.german_2.2_for_ST_124.0"
            "PAK128.german_2.2_for_ST_124.0.zip"
          ];
          prefix = "/PAK128.german";
          hash = "sha256-QafYmTFq8zb2NdH6EThQi9Zb+xmCqbxYABaEfzotPg0=";
        };
        "pak128.japan" = {
          fetcher = fetchcab;
          url = "http://pak128.jpn.org/souko/pak128.japan.120.0.cab";
          prefix = "/pak128.japan";
          hash = "sha256-dJOpYVdh55mHm3kCKBwlShl3+6I/TRBAkD7ivoFI1HI=";
        };

        "pak144.excentrique" = {
          # 124.0 ships a nightly tag of this pakset. We're using a permanent tag.
          # Upstream has been notified, and it has been fixed in their development branch.
          # The only consequence will be that the in-game downloader will break for this pakset.
          url = "https://github.com/Varkalandar/pak144.Excentrique/releases/download/r0.08/pak144.Excentrique_v008.zip";
          hash = "sha256-Iqe6enB3AD8BgaLshwTHjv61xfp9OMaoLwkfDakr53I=";
        };

        "pak192.comic" = {
          url = "https://github.com/Flemmbrav/Pak192.Comic/releases/download/V0.7.1/pak192.comic-serverset.zip";
          hash = "sha256-T3FdreBWA76wGdPSSF0G0YWQoPsmancJe2Nl7akFBz0=";
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
      inherit (binaries) name;
      paths = [ binaries ] ++ paks;
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
      # For backwards compatibility, it is desirable to default to ~/.simutrans still, but still use $XDG_DATA_HOME/simutrans.
      # That is what ${default-home} is for.
      # It will be set to $XDG_DATA_HOME/simutrans if $XDG_DATA_HOME is non-empty, otherwise it will be set to ~/.simutrans.
      # That's, again, not following the XDG basedir spec. It should be "${XDG_DATA_HOME:-$HOME/.local/share}/simutrans".
      #
      # Then, we use it to set defaults for SIMUTRANS_USERDIR and SIMUTRANS_INSTALLDIR.
      # These should be '--set-default's, but wrapProgram will only accept literal strings here.
      # We're reading from the environment, so we use --run instead.
      # A user can overwrite these values:
      # - Setting SIMUTRANS_USERDIR and SIMUTRANS_INSTALLDIR in the environment will take priority over these defaults.
      # - Setting SIMUTRANS_USERDIR and SIMUTRANS_INSTALLDIR to empty strings will disable them.
      # - Passing '-set_userdir' and '-set_installdir' to the game will take priority over the environment variables.
      postBuild =
        let
          default-home = ''$(if [ -n "$XDG_DATA_HOME" ]; then echo "$XDG_DATA_HOME/simutrans"; else echo "$HOME/.simutrans"; fi)'';
        in
        ''
          wrapProgram $out/bin/simutrans \
            --run 'export SIMUTRANS_USERDIR=''${SIMUTRANS_USERDIR-${default-home}}' \
            --run 'export SIMUTRANS_INSTALLDIR=''${SIMUTRANS_INSTALLDIR-${default-home}/paksets}' \
            --add-flags "-set_basedir $out/share/simutrans"
        '';

      strip = false;
      passthru.meta = binaries.meta // {
        hydraPlatforms = [ ];
      };
      passthru.binaries = binaries;
      passthru.pakSpec = pakSpec;
    };

  binaries = stdenv.mkDerivation {
    pname = "simutrans";
    inherit version src;

    sourceRoot = "simutrans-r${src.rev}/trunk";

    # We're building from the stable revision, but we still need to apply some patches.
    # These patches are all merged upstream. Generate them with `svn diff -r ${x-1}:${x}`.
    # Modified by hand to be prefixed with `a/` and `b/` and exclude the svn "Index:" line.
    # We're *not* building a newer revision because multiplayer compatibility depends on the revision number.
    patches = [
      # The Makefile contains a typo.
      # We need this to build.
      ./r11174.patch
      # The implementation of check_and_set_dir() is broken (rejects all user and install directories).
      # We depend on this function to set the user and install directories.
      ./r11175.patch
      # r11175 contains a use-after-free when validating the base directory.
      # I don't think it's exploitable on NixOS, but we should fix it anyway.
      ./r11178.patch
      # The fixed implementation of check_and_set_dir() still has a bug where it doesn't allow nonexistent directories.
      # We need this so that the overridden directories can be created on startup.
      # That can be worked around with `mkdir` in the wrapper but it's better to fix at the srouce.
      ./r11204.patch
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
      maintainers = with lib.maintainers; [ sodiboo ];
      platforms = lib.platforms.linux; # TODO: ++ darwin;
    };
  };
in
lib.makeOverridable ({ paks }: withPaks paks) {
  paks = lib.attrValues pakSpec;
}
