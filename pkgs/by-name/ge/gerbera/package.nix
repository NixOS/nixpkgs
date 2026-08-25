{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  nixosTests,

  # required deps
  # keep-sorted start case=no numeric=no block=yes
  fmt,
  icu77,
  jsoncpp,
  libiconv,
  libupnp,
  libuuid,
  pugixml,
  spdlog,
  sqlite,
  zlib,
  # keep-sorted end

  # optional deps
  # keep-sorted start case=no numeric=no group_start_regex=["^  enable"] newline_separated=2
  enableAvcodec ? false,
  ffmpeg,

  enableCurl ? true,
  curl,

  enableDuktape ? true,
  duktape,

  enableExiv2 ? false,
  exiv2,

  enableFFmpegThumbnailer ? false,
  ffmpegthumbnailer,

  enableInotifyTools ? true,
  inotify-tools,

  enableLibexif ? true,
  libexif,

  enableLibmagic ? true,
  file,

  enableLibmatroska ? true,
  libmatroska,
  libebml,

  enableMysql ? false,
  libmysqlclient,

  enablePgsql ? false,
  libpqxx,
  libpq,

  enableTaglib ? true,
  taglib,

  enableWavPack ? false,
  wavpack,

  enableZip ? true,
  libzippp,
  libzip,
  # keep-sorted end
}:

let
  libupnp' = libupnp.overrideAttrs (super: {
    cmakeFlags = super.cmakeFlags or [ ] ++ [
      "-Dblocking_tcp_connections=OFF"
      "-Dreuseaddr=ON"
    ];
  });

  options = [
    # keep-sorted start case=no numeric=no block=yes
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
      name = "PGSQL";
      enable = enablePgsql;
      packages = [
        libpqxx
        libpq
      ];
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
    {
      name = "ZIP";
      enable = enableZip;
      packages = [
        libzippp
        libzip
      ];
    }
    # keep-sorted end
  ];

  inherit (lib) flatten;

in
stdenv.mkDerivation (finalAttrs: {
  pname = "gerbera";
  version = "3.2.1";

  src = fetchFromGitHub {
    repo = "gerbera";
    owner = "gerbera";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6GEJjX0wDjwXHGgn5d0UOdAyPXS5jekDuI2SY82vOtM=";
  };

  patches = [
    # https://github.com/gerbera/gerbera/pull/3841
    # fixes build with newer gcc versions
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/gerbera/gerbera/pull/3841.patch";
      hash = "sha256-R43VBw9imoy8HJpjmtBzPgPQyHH5gLaDUymqhWrSj+w=";
    })
    # https://github.com/gerbera/gerbera/pull/3889
    # fixes build with newer gcc versions
    (fetchpatch {
      url = "https://github.com/gerbera/gerbera/commit/772a538e16d9585d3e5dd71cffa9953710f1ae9e.patch";
      hash = "sha256-2pR1l+Ss9CHZmdFDtso1vDv4yz9RhteOPS9wmycmUfs=";
    })
  ];

  postPatch =
    let
      mysqlPatch = lib.optionalString enableMysql ''
        substituteInPlace cmake/FindMySQL.cmake \
          --replace-fail /usr/include/mysql ${lib.getDev libmysqlclient}/include/mariadb \
          --replace-fail /usr/lib/mysql     ${lib.getLib libmysqlclient}/lib/mariadb
      '';
    in
    ''
      ${mysqlPatch}
      substituteInPlace CMakeLists.txt \
        --replace-fail /usr/share/bash-completion/completions ${placeholder "out"}/share/bash-completion/completions
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
    # keep-sorted start case=no numeric=no block=yes
    libiconv
    libupnp'
    pugixml
    spdlog
    sqlite
    zlib
    fmt
    jsoncpp
    icu77
    # keep-sorted end
  ]
  # "not required on *BSD"
  ++ lib.optional (!stdenv.hostPlatform.isBSD) libuuid
  ++ flatten (builtins.catAttrs "packages" (builtins.filter (e: e.enable) options));

  passthru.tests = { inherit (nixosTests) mediatomb; };

  meta = {
    homepage = "https://gerbera.io/";
    changelog = "https://github.com/gerbera/gerbera/releases/tag/v${finalAttrs.version}";
    description = "UPnP media server";
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
})
