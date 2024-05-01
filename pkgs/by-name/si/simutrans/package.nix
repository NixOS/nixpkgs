{
  lib,
  stdenv,
  fetchurl,
  fetchsvn,
  fetchzip,
  pkg-config,
  zlib,
  libpng,
  bzip2,
  SDL2,
  SDL2_mixer,
  config,
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

  # Choose your "paksets" of objects, images, text, music, etc.
  paksets = config.simutrans.paksets or "pak64 pak64.japan pak128 pak128.britain pak128.german";

  result = withPaks (
    if paksets == "*" then
      lib.attrValues pakSpec # taking all
    else
      map (name: pakSpec.${name}) (lib.splitString " " paksets)
  );

  version = "123.0.1";

  src = fetchsvn {
    url = "svn://servers.simutrans.org/simutrans";
    # The rev can be found in the forum thread for the release: https://forum.simutrans.com/index.php/board,3.0.html
    rev = "10421";
    hash = "sha256-3Mj2uuPO2qUeb91Q/MMF0LQKASdkuvtajwrYxyJTPJ4=";
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
          hash,

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
            "123-0"
            "simupak64-123-0.zip"
          ];
          prefix = "/pak";
          hash = "sha256-TZ9VqCIdSHcdQCtcOZzfomhTpONU+ecsltlocl2HZPk=";
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
          url = "https://simutrans-germany.com/pak.german/pak64.german_0-123-0-0-2_full.zip";
          prefix = "/pak64.german";
          hash = "sha256-nTbI7OK09u3fDYwoW6JpiwGkOoIXV2Rj+zgwHG+x7+I=";
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
            "pak128 2.8.2 for ST 123up"
            "simupak128-2.8.2-for123.zip"
          ];
          prefix = "/pak128";
          hash = "sha256-ILAbpaH3lsPVEEldzHxUvYPR50pYK+vOLHZkBgbypHY=";
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
          srcPath = [ "pak128.cz_v.0.2.1.zip" ];
          hash = "sha256-9NIlJzVjE7QRaKHvT9PZLxo2Xq8sUHCHdVoPqyTcgbY=";
        };
        "pak128.german" = {
          basePath = "PAK128.german";
          srcPath = [
            "PAK128.german_2.1_for_ST_123.0"
            "PAK128.german_2.1_for_ST_123.0.zip"
          ];
          prefix = "/PAK128.german";
          hash = "sha256-p6uR2h/uWrLMxFoKYZYdqVkg/9Q1uTcFMxKqm7W6ssA=";
        };
        "pak128.japan" = {
          fetcher = fetchcab;
          url = "http://pak128.jpn.org/souko/pak128.japan.120.0.cab";
          prefix = "/pak128.japan";
          hash = "sha256-dJOpYVdh55mHm3kCKBwlShl3+6I/TRBAkD7ivoFI1HI=";
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
      # Normally simutrans will look for paksets in the executable's directory ($out/bin),
      # but we keep them in $out/share/simutrans so we chdir into there
      # and pass -use_workdir to tell the game to look in the working directory instead.
      # The Simutrans team told me that 124.0 will have a better solution for this.
      postBuild = ''
        wrapProgram $out/bin/simutrans \
          --chdir $out/share/simutrans \
          --add-flags '-use_workdir'
      '';

      passthru.meta = binaries.meta // {
        hydraPlatforms = [ ];
      };
      passthru.binaries = binaries;
    };

  binaries = stdenv.mkDerivation {
    pname = "simutrans";
    inherit version src;

    sourceRoot = "simutrans-r${src.rev}/trunk";

    # When you press the "Install" button in the pakset selection menu,
    # normally the game will call `get_pak.sh`, which will download the pakset.
    #
    # It doesn't work on nix, because it wants to download the pakset into the working directory
    # but that is read-only in nix. One solution is to implement a stub that tells the user
    # to add the pakset to nixpkgs. But there's no easy way to display this in the gui.
    # So, it would just fail silently, which is bad. Originally, my hope is that a typical NixOS user
    # will be able to figure out what's going on. That user might be you! If you're reading this,
    # and want your pakset in nixpkgs, please add it to pakSpec.
    #
    # But, in general, for a real implementation, `get_pak.sh` needs to download into a game-readable directory.
    # This means that the game needs to read from both $out/share/simutrans and something under ~/.simutrans.
    # Currently, the game can't do that. It can only read from one directory at a time.
    # According to discussion in #developing on the Simutrans Discord, this is already part of the nightly builds.
    # So, in the next release, we should implement `get_pak.sh` to download into ~/.simutrans.
    #
    # In the meanwhile, the "Install" button is useless. Given that the paksets are already in the pakSpec above,
    # i figured it's fine to just disable it. After some back and forth with the Simutrans team, i was told, and i quote:
    # "It should be possible to change the C++ code so that it would work the way you want it to be"
    # So, i did that. I made a patch that hides the "Install" button.
    # For the options menu, we also set the button to be "rigid" so that the rest of the menu doesn't shift around.
    patches = [ ./disable_install_pakset.patch ];

    nativeBuildInputs = [ pkg-config ];
    buildInputs = [
      zlib
      libpng
      bzip2
      SDL2
      SDL2_mixer
    ];

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
      #TODO: MULTI_THREAD = 1 is "highly recommended",
      # but it's roughly doubling CPU usage for me
      ''
        BACKEND := sdl2
        OSTYPE := ${platform}
        VERBOSE := 1
        OPTIMISE := 1
        FLAGS := -DREVISION=${src.rev}
      '';

    passAsFile = [ "configuration" ];

    configurePhase = ''
      cp $configurationPath config.default

      # Use ~/.simutrans instead of ~/simutrans
      substituteInPlace sys/simsys.cc --replace-fail '%s/simutrans' '%s/.simutrans'
    '';

    enableParallelBuilding = true;

    installPhase = ''
      mkdir -p $out/{bin,share}
      mv simutrans $out/share/simutrans
      mv build/default/sim $out/bin/simutrans
    '';

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
result
