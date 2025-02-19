{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt5,
  perl,

  # Cantata doesn't build with cdparanoia enabled so we disable that
  # default for now until I (or someone else) figure it out.
  withCdda ? false,
  cdparanoia,
  withCddb ? false,
  libcddb,
  withLame ? false,
  lame,
  withMusicbrainz ? false,
  libmusicbrainz5,

  withTaglib ? true,
  taglib,
  taglib_extras,
  withHttpStream ? true,
  withReplaygain ? true,
  ffmpeg,
  speex,
  mpg123,
  withMtp ? true,
  libmtp,
  withOnlineServices ? true,
  withDevices ? true,
  udisks2,
  withDynamic ? true,
  withHttpServer ? true,
  withLibVlc ? false,
  libvlc,
  withStreams ? true,
}:

# Inter-dependencies.
assert withCddb -> withCdda && withTaglib;
assert withCdda -> withCddb && withMusicbrainz;
assert withLame -> withCdda && withTaglib;
assert withMtp -> withTaglib;
assert withMusicbrainz -> withCdda && withTaglib;
assert withOnlineServices -> withTaglib;
assert withReplaygain -> withTaglib;
assert withLibVlc -> withHttpStream;

let
  fstat = x: fn: "-DENABLE_${fn}=${if x then "ON" else "OFF"}";

  withUdisks = (withTaglib && withDevices && stdenv.hostPlatform.isLinux);

  options = [
    {
      names = [ "CDDB" ];
      enable = withCddb;
      pkgs = [ libcddb ];
    }
    {
      names = [ "CDPARANOIA" ];
      enable = withCdda;
      pkgs = [ cdparanoia ];
    }
    {
      names = [ "DEVICES_SUPPORT" ];
      enable = withDevices;
      pkgs = [ ];
    }
    {
      names = [ "DYNAMIC" ];
      enable = withDynamic;
      pkgs = [ ];
    }
    {
      names = [
        "FFMPEG"
        "MPG123"
        "SPEEXDSP"
      ];
      enable = withReplaygain;
      pkgs = [
        ffmpeg
        speex
        mpg123
      ];
    }
    {
      names = [ "HTTPS_SUPPORT" ];
      enable = true;
      pkgs = [ ];
    }
    {
      names = [ "HTTP_SERVER" ];
      enable = withHttpServer;
      pkgs = [ ];
    }
    {
      names = [ "HTTP_STREAM_PLAYBACK" ];
      enable = withHttpStream;
      pkgs = [ qt5.qtmultimedia ];
    }
    {
      names = [ "LAME" ];
      enable = withLame;
      pkgs = [ lame ];
    }
    {
      names = [ "LIBVLC" ];
      enable = withLibVlc;
      pkgs = [ libvlc ];
    }
    {
      names = [ "MTP" ];
      enable = withMtp;
      pkgs = [ libmtp ];
    }
    {
      names = [ "MUSICBRAINZ" ];
      enable = withMusicbrainz;
      pkgs = [ libmusicbrainz5 ];
    }
    {
      names = [ "ONLINE_SERVICES" ];
      enable = withOnlineServices;
      pkgs = [ ];
    }
    {
      names = [ "STREAMS" ];
      enable = withStreams;
      pkgs = [ ];
    }
    {
      names = [
        "TAGLIB"
        "TAGLIB_EXTRAS"
      ];
      enable = withTaglib;
      pkgs = [
        taglib
        taglib_extras
      ];
    }
    {
      names = [ "UDISKS2" ];
      enable = withUdisks;
      pkgs = [ udisks2 ];
    }
  ];

in
stdenv.mkDerivation (finalAttrs: {
  pname = "cantata";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "CDrummond";
    repo = "cantata";
    rev = "v${finalAttrs.version}";
    hash = "sha256-UaZEKZvCA50WsdQSSJQQ11KTK6rM4ouCHDX7pn3NlQw=";
  };

  patches = [
    # Cantata wants to check if perl is in the PATH at runtime, but we
    # patchShebangs the playlists scripts, making that unnecessary (perl will
    # always be available because it's a dependency)
    ./dont-check-for-perl-in-PATH.diff
  ];

  postPatch = ''
    patchShebangs playlists
  '';

  buildInputs = [
    qt5.qtbase
    qt5.qtsvg
    (perl.withPackages (ppkgs: with ppkgs; [ URI ]))
  ] ++ lib.flatten (builtins.catAttrs "pkgs" (builtins.filter (e: e.enable) options));

  nativeBuildInputs = [
    cmake
    pkg-config
    qt5.qttools
    qt5.wrapQtAppsHook
  ];

  cmakeFlags = lib.flatten (map (e: map (f: fstat e.enable f) e.names) options);

  meta = {
    description = "Graphical client for MPD";
    mainProgram = "cantata";
    homepage = "https://github.com/cdrummond/cantata";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ peterhoeg ];
    # Technically, Cantata should run on Darwin/Windows so if someone wants to
    # bother figuring that one out, be my guest.
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
  };
})
