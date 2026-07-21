# DO *NOT* MODIFY THE LINES CONTAINING "hash = ..." OR "version = ...".
# THEY ARE GENERATED. SEE ./update.sh.
{
  fetchzip,
  libjpeg,
  netcdf,
  pkgs,
  stdenv,
}:

let
  mkGeoserverExtension =
    {
      name,
      version,
      hash,
      buildInputs ? [ ],
    }:
    stdenv.mkDerivation {
      pname = "geoserver-${name}-extension";
      inherit buildInputs version;

      src = fetchzip {
        url = "https://sourceforge.net/projects/geoserver/files/GeoServer/${version}/extensions/geoserver-${version}-${name}-plugin.zip";
        inherit hash;
        # We expect several files.
        stripRoot = false;
      };

      installPhase = ''
        runHook preInstall

        DIR=$out/share/geoserver/webapps/geoserver/WEB-INF/lib
        mkdir -p $DIR
        cp -r $src/* $DIR

        runHook postInstall
      '';
    };
in

{
  app-schema = mkGeoserverExtension {
    name = "app-schema";
    version = "3.0.0"; # app-schema
    hash = "sha256-dnby18mrcbgP8pglFiW+bAhuBMMCl8ERZUejHgxAb9c="; # app-schema
  };

  authkey = mkGeoserverExtension {
    name = "authkey";
    version = "3.0.0"; # authkey
    hash = "sha256-Sc2gctLyc+6vJyRzzp/f7h2ELdITnzlOicZHkwFPQ74="; # authkey
  };

  cas = mkGeoserverExtension {
    name = "cas";
    version = "3.0.0"; # cas
    hash = "sha256-U+bz8lIpj7cJKcnolUvA4leWtxU3MTSu/QRvSTVANZY="; # cas
  };

  charts = mkGeoserverExtension {
    name = "charts";
    version = "3.0.0"; # charts
    hash = "sha256-LA/3uWAYOwFXTrjvflOlkGkYn1lObuY15ngjLVXwFlk="; # charts
  };

  control-flow = mkGeoserverExtension {
    name = "control-flow";
    version = "3.0.0"; # control-flow
    hash = "sha256-S6EV4HbCxWruNCQSoCFqNT1LlueMeh1/YmlbfHLRKxU="; # control-flow
  };

  css = mkGeoserverExtension {
    name = "css";
    version = "3.0.0"; # css
    hash = "sha256-bISJcDQMd9a15uST+IdrpTiJD+5uG+rCWAnyVGA996c="; # css
  };

  csw = mkGeoserverExtension {
    name = "csw";
    version = "3.0.0"; # csw
    hash = "sha256-gLc64xbYzeF6A2Tmce2SvMMMBzyjE7cnjS3Kx5A96hs="; # csw
  };

  csw-iso = mkGeoserverExtension {
    name = "csw-iso";
    version = "3.0.0"; # csw-iso
    hash = "sha256-mtkQUpzvNFX3sdiz3JX3qnwzKA7WdoR+y3Ukzd0LkuE="; # csw-iso
  };

  db2 = mkGeoserverExtension {
    name = "db2";
    version = "3.0.0"; # db2
    hash = "sha256-zAXNvn5wXbY7LbPPV43BSWG5oPgyYtjRwgJB90brkaw="; # db2
  };

  # Needs wps extension.
  dxf = mkGeoserverExtension {
    name = "dxf";
    version = "3.0.0"; # dxf
    hash = "sha256-YzZihHDKDyFIbzcLHlxmRNJIgdsbuVLcedN3lfWH1dc="; # dxf
  };

  excel = mkGeoserverExtension {
    name = "excel";
    version = "3.0.0"; # excel
    hash = "sha256-NCU8j7muqU48Q1a4GmUYuspvTJWaPc0y8Q6grFeJ0aQ="; # excel
  };

  feature-pregeneralized = mkGeoserverExtension {
    name = "feature-pregeneralized";
    version = "3.0.0"; # feature-pregeneralized
    hash = "sha256-95dspATAdwTdAn2wYL7jGH6fPxOKiFK/HR+ikRDg5/w="; # feature-pregeneralized
  };

  # Note: The extension name ("gdal") clashes with pkgs.gdal.
  gdal = mkGeoserverExtension {
    name = "gdal";
    version = "3.0.0"; # gdal
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-D4tpyiXtH9f/ZteRxaUUMPCsHycmf/pjKThfgQIwiSs="; # gdal
  };

  geopkg-output = mkGeoserverExtension {
    name = "geopkg-output";
    version = "3.0.0"; # geopkg-output
    hash = "sha256-EQKVfu6/6vNmseLiUAIhtNW6FA/0Pi9nSRlaa7aNHig="; # geopkg-output
  };

  grib = mkGeoserverExtension {
    name = "grib";
    version = "3.0.0"; # grib
    hash = "sha256-6SMO5fyNQvOwukqqw0TqW1utSuCcj/Vq1jX9GkVAxl4="; # grib
    buildInputs = [ netcdf ];
  };

  gwc-s3 = mkGeoserverExtension {
    name = "gwc-s3";
    version = "3.0.0"; # gwc-s3
    hash = "sha256-YATqbj8cfafLXe8EdBti4qQP1ZLgL+VbeloUGjGwR7c="; # gwc-s3
  };

  iau = mkGeoserverExtension {
    name = "iau";
    version = "3.0.0"; # iau
    hash = "sha256-pkzbQJTrcjKUKDQz0Jp0RWXg0ousqsPPbJYeoFKOups="; # iau
  };

  importer = mkGeoserverExtension {
    name = "importer";
    version = "3.0.0"; # importer
    hash = "sha256-BYYrGCFwxuss4fsRBDTaTCimmykIq3lCfr0RiiBAw2A="; # importer
  };

  inspire = mkGeoserverExtension {
    name = "inspire";
    version = "3.0.0"; # inspire
    hash = "sha256-3U0DHrk0YAUluohQAUKPPUaz9oYiKQQGh0gZs4Xnh8A="; # inspire
  };

  # Needs Kakadu plugin from
  # https://github.com/geosolutions-it/imageio-ext
  #jp2k = mkGeoserverExtension {
  #  name = "jp2k";
  #  version = "3.0.0"; # jp2k
  #  hash = "sha256-tQesDwFgdPF8bVFOXkMqxURIwtak+vyNCQcKgfD0F3s="; # jp2k
  #};

  # Throws "java.lang.UnsatisfiedLinkError: 'void org.libjpegturbo.turbojpeg.TJDecompressor.init()'"
  # as of 2.28.1.
  # NOTE: When re-enabling this, RE-ENABLE THE CORRESPONDING TEST, TOO! (See tests/geoserver.nix)
  #libjpeg-turbo = mkGeoserverExtension {
  #  name = "libjpeg-turbo";
  #  version = "3.0.0"; # libjpeg-turbo
  #  hash = "sha256-ckcyiZG2aoqwXGuNMF6pmi2ZjGjY8r851OOB4nQtvIo="; # libjpeg-turbo
  #  buildInputs = [ libjpeg.out ];
  #};

  mapml = mkGeoserverExtension {
    name = "mapml";
    version = "3.0.0"; # mapml
    hash = "sha256-QKl1S0+w1Do12fbe1H1zw5PZnAbRNZ7Di83uCJLwO4I="; # mapml
  };

  mbstyle = mkGeoserverExtension {
    name = "mbstyle";
    version = "3.0.0"; # mbstyle
    hash = "sha256-bIbJ1eAYvR6FdtTk6vvQi22BFuv4qxiT2VDZbt1c00E="; # mbstyle
  };

  metadata = mkGeoserverExtension {
    name = "metadata";
    version = "3.0.0"; # metadata
    hash = "sha256-OFP+q8LznAP0qhK2PTFCxcEQjXaQgX0bWOYh3R6V2Xo="; # metadata
  };

  mongodb = mkGeoserverExtension {
    name = "mongodb";
    version = "3.0.0"; # mongodb
    hash = "sha256-9ad03z2cPsLBKZUwGgHrKaiTvwEtCxKyor5im6H6eBU="; # mongodb
  };

  monitor = mkGeoserverExtension {
    name = "monitor";
    version = "3.0.0"; # monitor
    hash = "sha256-KLb983PxIGuKXq+glG9f71mYiUk5pshuF5C6eCZUuCU="; # monitor
  };

  mysql = mkGeoserverExtension {
    name = "mysql";
    version = "3.0.0"; # mysql
    hash = "sha256-CH4OOafHV8B92yLuwv85Te8Vg8vCgz+KUHzSrS+nDD0="; # mysql
  };

  netcdf = mkGeoserverExtension {
    name = "netcdf";
    version = "3.0.0"; # netcdf
    hash = "sha256-kftON+b5q5WuoVYa5haxkgm5fwvpCbMIiaYPm1GphLE="; # netcdf
    buildInputs = [ netcdf ];
  };

  netcdf-out = mkGeoserverExtension {
    name = "netcdf-out";
    version = "3.0.0"; # netcdf-out
    hash = "sha256-FmJHU+F4AB5idhexF1j3I24Apx6HBviJ7pUW7nkdzGY="; # netcdf-out
    buildInputs = [ netcdf ];
  };

  ogr-wfs = mkGeoserverExtension {
    name = "ogr-wfs";
    version = "3.0.0"; # ogr-wfs
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-o7RD99jbtktLtcujYPO2nILPTOmsjF+ZVgHeyJmmgSw="; # ogr-wfs
  };

  # Needs ogr-wfs extension.
  ogr-wps = mkGeoserverExtension {
    name = "ogr-wps";
    version = "3.0.0"; # ogr-wps
    # buildInputs = [ pkgs.gdal ];
    hash = "sha256-tIxYBCVkx2IlOYTUEAln6FgxBTXwuw7XEEl8wqE+OF8="; # ogr-wps
  };

  oracle = mkGeoserverExtension {
    name = "oracle";
    version = "3.0.0"; # oracle
    hash = "sha256-CcBeaFU42WG+YzfGl/6aQji4D66H6FdjmkSHGFK2Hn0="; # oracle
  };

  params-extractor = mkGeoserverExtension {
    name = "params-extractor";
    version = "3.0.0"; # params-extractor
    hash = "sha256-qtRu7CBmZWFTBrkOeQFC/fGAaJNhW0MUZUayqPw8PBE="; # params-extractor
  };

  printing = mkGeoserverExtension {
    name = "printing";
    version = "3.0.0"; # printing
    hash = "sha256-hRhOclptkTv/RB44UQ8v2h9RtdD65dYmQvT6Eia5Ars="; # printing
  };

  pyramid = mkGeoserverExtension {
    name = "pyramid";
    version = "3.0.0"; # pyramid
    hash = "sha256-pkuTzANjQyS8l328Cn83yheJBi5KcVgizVpvxkxu5To="; # pyramid
  };

  querylayer = mkGeoserverExtension {
    name = "querylayer";
    version = "3.0.0"; # querylayer
    hash = "sha256-uIX7x56O4pmjCmsK5SHL9ucD/7OYAAew0xhuemxHym4="; # querylayer
  };

  sldservice = mkGeoserverExtension {
    name = "sldservice";
    version = "3.0.0"; # sldservice
    hash = "sha256-vYgl3vqv5jxuNT7OJLAxw7D2LiQdreBPs7IW6X8hJEU="; # sldservice
  };

  sqlserver = mkGeoserverExtension {
    name = "sqlserver";
    version = "3.0.0"; # sqlserver
    hash = "sha256-NPaprYtCQGanNCWlLHypmmNPAhYutq6orm/awJDRPqY="; # sqlserver
  };

  vectortiles = mkGeoserverExtension {
    name = "vectortiles";
    version = "3.0.0"; # vectortiles
    hash = "sha256-UWCQG1IKCKI1V0u8BR2duV2H0Oo7TpPBAbSjXmfKNwo="; # vectortiles
  };

  wcs2_0-eo = mkGeoserverExtension {
    name = "wcs2_0-eo";
    version = "3.0.0"; # wcs2_0-eo
    hash = "sha256-ATH0taOpIOwIfncjavQtyMf2dxqxTe8SbSbLT5WlfOk="; # wcs2_0-eo
  };

  web-resource = mkGeoserverExtension {
    name = "web-resource";
    version = "3.0.0"; # web-resource
    hash = "sha256-jC1g/ZzdxdQBwKWDzctpIM+Ke6V3ZjGvGdBX0td4Rqc="; # web-resource
  };

  wmts-multi-dimensional = mkGeoserverExtension {
    name = "wmts-multi-dimensional";
    version = "3.0.0"; # wmts-multi-dimensional
    hash = "sha256-RVbRthZvm849rxUSwvq2BgT9EFgFZJ5MI1ioQWGLaYA="; # wmts-multi-dimensional
  };

  wps = mkGeoserverExtension {
    name = "wps";
    version = "3.0.0"; # wps
    hash = "sha256-sKXpodTATiLgCjt3fmql4mqwamlo4F7QJ9Ok4Knmtms="; # wps
  };

  # Needs hazelcast (https://github.com/hazelcast/hazelcast (?)) which is not
  # available in nixpgs as of 2024/01.
  #wps-cluster-hazelcast = mkGeoserverExtension {
  #  name = "wps-cluster-hazelcast";
  #  version = "3.0.0"; # wps-cluster-hazelcast
  #  hash = "sha256-zPAgyzERMvcnsc5Q/tE3gyRjd+35DnYDvZ3lNCbx4mw="; # wps-cluster-hazelcast
  #};

  wps-download = mkGeoserverExtension {
    name = "wps-download";
    version = "3.0.0"; # wps-download
    hash = "sha256-fW5TgcsF2GBs7uXohiLkhgVP2LHoqio4wn9+5Nu7NUc="; # wps-download
  };

  # Needs Postrgres configuration or similar.
  # See https://docs.geoserver.org/main/en/user/extensions/wps-jdbc/index.html
  wps-jdbc = mkGeoserverExtension {
    name = "wps-jdbc";
    version = "3.0.0"; # wps-jdbc
    hash = "sha256-TOl0FeqKR12bU9LufkLZelTlXrPage9uOWdTLRTXpYk="; # wps-jdbc
  };

  ysld = mkGeoserverExtension {
    name = "ysld";
    version = "3.0.0"; # ysld
    hash = "sha256-H8JngVk3Tuifv47rL3xQDC2r0TYuLIPEaysaP8RpUrc="; # ysld
  };

}
