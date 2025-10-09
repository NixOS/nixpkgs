{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  nixosTests,
  # required
  libiconv,
  libupnp,
  libuuid,
  pugixml,
  spdlog,
  sqlite,
  zlib,
  fmt,
  # options
  enableMysql ? false,
  libmysqlclient,
  enableDuktape ? true,
  duktape,
  enableCurl ? true,
  curl,
  enableTaglib ? true,
  taglib,
  enableLibmagic ? true,
  file,
  enableLibmatroska ? true,
  libmatroska,
  libebml,
  enableAvcodec ? false,
  ffmpeg,
  enableLibexif ? true,
  libexif,
  enableExiv2 ? false,
  exiv2,
  enableFFmpegThumbnailer ? false,
  ffmpegthumbnailer,
  enableInotifyTools ? true,
  inotify-tools,
  wavpack,
  enableWavPack ? false,
}:

let
  libupnp' = libupnp.overrideAttrs (super: {
    cmakeFlags = super.cmakeFlags or [ ] ++ [
      "-Dblocking_tcp_connections=OFF"
      "-Dreuseaddr=ON"
    ];
  });

  options = [
    {
      name = "AVCODEC";
      enable = enableAvcodec;
      packages = [ ffmpeg ];
    }
    {
      name = "CURL";
      enable = enableCurl;
      packages = [ curl ];
    }
    {
      name = "EXIF";
      enable = enableLibexif;
      packages = [ libexif ];
    }
    {
      name = "EXIV2";
      enable = enableExiv2;
      packages = [ exiv2 ];
    }
    {
      name = "FFMPEGTHUMBNAILER";
      enable = enableFFmpegThumbnailer;
      packages = [ ffmpegthumbnailer ];
    }
    {
      name = "INOTIFY";
      enable = enableInotifyTools;
      packages = [ inotify-tools ];
    }
    {
      name = "JS";
      enable = enableDuktape;
      packages = [ duktape ];
    }
    {
      name = "MAGIC";
      enable = enableLibmagic;
      packages = [ file ];
    }
    {
      name = "MATROSKA";
      enable = enableLibmatroska;
      packages = [
        libmatroska
        libebml
      ];
    }
    {
      name = "MYSQL";
      enable = enableMysql;
      packages = [ libmysqlclient ];
    }
    {
      name = "TAGLIB";
      enable = enableTaglib;
      packages = [ taglib ];
    }
    {
      name = "WAVPACK";
      enable = enableWavPack;
      packages = [ wavpack ];
    }
  ];

  inherit (lib) flatten;

in
stdenv.mkDerivation rec {
  pname = "gerbera";
  version = "2.5.0";

  src = fetchFromGitHub {
    repo = "gerbera";
    owner = "gerbera";
    rev = "v${version}";
    sha256 = "sha256-3X8/8ewqXy9tvy4S9frmPENhsYTwaW6SydtJeiyVH1I=";
  };

  postPatch =
    let
      mysqlPatch = lib.optionalString enableMysql ''
        substituteInPlace cmake/FindMySQL.cmake \
          --replace /usr/include/mysql ${lib.getDev libmysqlclient}/include/mariadb \
          --replace /usr/lib/mysql     ${lib.getLib libmysqlclient}/lib/mariadb
      '';
    in
    ''
      ${mysqlPatch}
    '';

  cmakeFlags = [
    # systemd service will be generated alongside the service
    "-DWITH_SYSTEMD=OFF"
  ]
  ++ map (e: "-DWITH_${e.name}=${if e.enable then "ON" else "OFF"}") options;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libiconv
    libupnp'
    libuuid
    pugixml
    spdlog
    sqlite
    zlib
    fmt
  ]
  ++ flatten (builtins.catAttrs "packages" (builtins.filter (e: e.enable) options));

  passthru.tests = { inherit (nixosTests) mediatomb; };

  meta = {
    homepage = "https://docs.gerbera.io/";
    changelog = "https://github.com/gerbera/gerbera/releases/tag/v${version}";
    description = "UPnP Media Server for 2024";
    longDescription = ''
      Gerbera is a Mediatomb fork.
      It allows to stream your digital media through your home network and consume it on all kinds
      of UPnP supporting devices.
    '';
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ ardumont ];
    platforms = lib.platforms.linux;
    mainProgram = "gerbera";
  };
}
