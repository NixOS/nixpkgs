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
    version = "2.28.3"; # app-schema
    hash = "sha256-fxMFV5/lvhCcgRfL+2Qf0ePo6EC/bLM1IeL5qNoKVrQ="; # app-schema
  };

  authkey = mkGeoserverExtension {
    name = "authkey";
    version = "2.28.3"; # authkey
    hash = "sha256-pAB8vPn+cZnKQKGLHtXrkLbieTs7wMi6ArGL8fxo31s="; # authkey
  };

  cas = mkGeoserverExtension {
    name = "cas";
    version = "2.28.3"; # cas
    hash = "sha256-BEDE9dZ4sZBr15Wvbpio9JOIEai53cJLe4QhvYbQwKw="; # cas
  };

  charts = mkGeoserverExtension {
    name = "charts";
    version = "2.28.3"; # charts
    hash = "sha256-cFbMdIIQwZudSgDBW8YN81GduG1bSQFLldjtubaclqA="; # charts
  };

  control-flow = mkGeoserverExtension {
    name = "control-flow";
    version = "2.28.3"; # control-flow
    hash = "sha256-HrS+/QntfSdMHLzA1+wJh7JWA2THLSOBDdIdeG7I4u4="; # control-flow
  };

  css = mkGeoserverExtension {
    name = "css";
    version = "2.28.3"; # css
    hash = "sha256-7gYg4v8ekThV3k21hrJlu6jULJxdyUFZZh0ToaZSyeI="; # css
  };

  csw = mkGeoserverExtension {
    name = "csw";
    version = "2.28.3"; # csw
    hash = "sha256-C/Th+KjiGWCfzMvVpby22BxXnkEtAYg1asYjO/Ge0fA="; # csw
  };

  csw-iso = mkGeoserverExtension {
    name = "csw-iso";
    version = "2.28.3"; # csw-iso
    hash = "sha256-ctZgjCQDLZKHAmd2Og+Vvu7iYxCU+08pTniImDDjmz0="; # csw-iso
  };

  db2 = mkGeoserverExtension {
    name = "db2";
    version = "2.28.3"; # db2
    hash = "sha256-yVghGPW07USGx4ZYs6F2P5VuGbNaUo3wzOrx1BOvFkE="; # db2
  };

  # Needs wps extension.
  dxf = mkGeoserverExtension {
    name = "dxf";
    version = "2.28.3"; # dxf
    hash = "sha256-o40HBSTzAmaUdCHslpBnK8ALHKh36V8PqmGzqdAtl7w="; # dxf
  };

  excel = mkGeoserverExtension {
    name = "excel";
    version = "2.28.3"; # excel
    hash = "sha256-7kOEb3ayiUZs0PV8qSiz+FuniWI1JEfod7wcf4e+1LM="; # excel
  };

  feature-pregeneralized = mkGeoserverExtension {
    name = "feature-pregeneralized";
    version = "2.28.3"; # feature-pregeneralized
    hash = "sha256-/6qvxhpg5HG+FlTsUclxxEfAYdhqV/cefDAta1Iw3sg="; # feature-pregeneralized
  };

  # Note: The extension name ("gdal") clashes with pkgs.gdal.
  gdal = mkGeoserverExtension {
    name = "gdal";
    version = "2.28.3"; # gdal
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-0IFF+x7T6qupakRx0Y+nwlVAC4byiDDCqovdPewdJWY="; # gdal
  };

  # Throws "java.io.FileNotFoundException: URL [jar:file:/nix/store/.../WEB-INF/lib/gs-geofence-server-2.24.1.jar!/geofence-default-override.properties] cannot be resolved to absolute file path because it does not reside in the file system: jar:file:/nix/store/.../WEB-INF/lib/gs-geofence-server-2.24.1.jar!/geofence-default-override.properties" but seems to work out of the box.
  #geofence = mkGeoserverExtension {
  #  name = "geofence";
  #  version = "2.28.3"; # geofence
  #  hash = "sha256-IQ+s6Q/nEnUAKfCdWQNhVNIEOWyi2VhDxMxWg4lfWKI="; # geofence
  #};

  #geofence-server-h2 = mkGeoserverExtension {
  #  name = "geofence-server-h2";
  #  version = "2.28.3"; # geofence-server
  #  hash = "sha256-WqzBPh0YNMcLbrKdNcYNZSQrVYPYczC/+uIw4I58A14="; # geofence-server-h2
  #};

  #geofence-server-postgres = mkGeoserverExtension {
  #  name = "geofence-server-postgres";
  #  version = "2.28.3"; # geofence-server
  #  hash = "sha256-ox7EjhVcetJInONerxtLK4MQt4BPIZ9EtPmmK6cnKJY="; # geofence-server-postgres
  #};

  #geofence-wps = mkGeoserverExtension {
  #  name = "geofence-wps";
  #  version = "2.28.3"; # geofence-wps
  #  hash = "sha256-txQwmE8mkCttfd57JFYbVuwIpfY+FFzb/hMcGEiEeW4="; # geofence-wps
  #};

  geopkg-output = mkGeoserverExtension {
    name = "geopkg-output";
    version = "2.28.3"; # geopkg-output
    hash = "sha256-JlMDDHvieYPTdKzYJxALzVrVZ+Jce447lq99hRQwP6Y="; # geopkg-output
  };

  grib = mkGeoserverExtension {
    name = "grib";
    version = "2.28.3"; # grib
    hash = "sha256-ydDlRbTxxieQkeSHAR4gf1+KrjvjGBQhAEyTc0jTN9E="; # grib
    buildInputs = [ netcdf ];
  };

  gwc-s3 = mkGeoserverExtension {
    name = "gwc-s3";
    version = "2.28.3"; # gwc-s3
    hash = "sha256-OsfS7b4w6PsJ6s20wn09FFJzjMv32iZldF9T8qaHH8A="; # gwc-s3
  };

  h2 = mkGeoserverExtension {
    name = "h2";
    version = "2.28.3"; # h2
    hash = "sha256-3B0WJrYG7UaHHt2p98zd5mWPJWKz3J/R7iwH4b2PLe4="; # h2
  };

  iau = mkGeoserverExtension {
    name = "iau";
    version = "2.28.3"; # iau
    hash = "sha256-oIgED4jwp5QENorSdWSvj3Pvy92dSF/Pjm6YwdZrbw8="; # iau
  };

  importer = mkGeoserverExtension {
    name = "importer";
    version = "2.28.3"; # importer
    hash = "sha256-6ZCmlzu5/sN76ZgVDtU02L9D/aNL+kawcf/EKakdlgU="; # importer
  };

  inspire = mkGeoserverExtension {
    name = "inspire";
    version = "2.28.3"; # inspire
    hash = "sha256-O/WPgBfyyI/sHZK9xGMjlYf4qyTT7Sx3psYWbjV3z1E="; # inspire
  };

  # Needs Kakadu plugin from
  # https://github.com/geosolutions-it/imageio-ext
  #jp2k = mkGeoserverExtension {
  #  name = "jp2k";
  #  version = "2.28.3"; # jp2k
  #  hash = "sha256-rLwuY5aEIKrjgyAXexFEpsRt+pNZLxI/YFo0yiBCblc="; # jp2k
  #};

  # Throws "java.lang.UnsatisfiedLinkError: 'void org.libjpegturbo.turbojpeg.TJDecompressor.init()'"
  # as of 2.28.1.
  # NOTE: When re-enabling this, RE-ENABLE THE CORRESPONDING TEST, TOO! (See tests/geoserver.nix)
  #libjpeg-turbo = mkGeoserverExtension {
  #  name = "libjpeg-turbo";
  #  version = "2.28.3"; # libjpeg-turbo
  #  hash = "sha256-cftD9VyJCxkYQBKuyBtnEeBAchYOAJGnl677MQAAdc4="; # libjpeg-turbo
  #  buildInputs = [ libjpeg.out ];
  #};

  mapml = mkGeoserverExtension {
    name = "mapml";
    version = "2.28.3"; # mapml
    hash = "sha256-r7GJbqCAnsxJV8zyHQG8EP3sbiXcfpQHNgMmj7viJac="; # mapml
  };

  mbstyle = mkGeoserverExtension {
    name = "mbstyle";
    version = "2.28.3"; # mbstyle
    hash = "sha256-RtxnQoWUSHOfizRS1eYR+o+n9HXpCt+bG1UOxFyRy9I="; # mbstyle
  };

  metadata = mkGeoserverExtension {
    name = "metadata";
    version = "2.28.3"; # metadata
    hash = "sha256-lFnZhs3FdGlQ4J37erOjLVB5QuRo6E0IUvAgONqvP4U="; # metadata
  };

  mongodb = mkGeoserverExtension {
    name = "mongodb";
    version = "2.28.3"; # mongodb
    hash = "sha256-M9l7jdp7oUfo0gMVfMcCVHizi0//YfBqh17tsiDMKno="; # mongodb
  };

  monitor = mkGeoserverExtension {
    name = "monitor";
    version = "2.28.3"; # monitor
    hash = "sha256-HPdoKySCLT3zVdOlNIuJlEu99mJ9J/VjTFEfT63UdUs="; # monitor
  };

  mysql = mkGeoserverExtension {
    name = "mysql";
    version = "2.28.3"; # mysql
    hash = "sha256-w/owOCOXJnw7EoJdPO8NGEw75MEfNMWSCySh0+2x84E="; # mysql
  };

  netcdf = mkGeoserverExtension {
    name = "netcdf";
    version = "2.28.3"; # netcdf
    hash = "sha256-2O7s7SUjAm/V+O2LrdqOLou12WkjxIg0zuIgRMFUp9M="; # netcdf
    buildInputs = [ netcdf ];
  };

  netcdf-out = mkGeoserverExtension {
    name = "netcdf-out";
    version = "2.28.3"; # netcdf-out
    hash = "sha256-KgqbHHxBlr0EIPJ1MStCPzV/844C3CUUBuBMe2ljbuA="; # netcdf-out
    buildInputs = [ netcdf ];
  };

  ogr-wfs = mkGeoserverExtension {
    name = "ogr-wfs";
    version = "2.28.3"; # ogr-wfs
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-+l9U1YoiKn1nxOUP5tRT/9WPRham5Lrk12xt/9rrZuM="; # ogr-wfs
  };

  # Needs ogr-wfs extension.
  ogr-wps = mkGeoserverExtension {
    name = "ogr-wps";
    version = "2.28.3"; # ogr-wps
    # buildInputs = [ pkgs.gdal ];
    hash = "sha256-PBqObn/gle6A8RVPmKOPhi2YNTqR2MmhbqZT3X7TygI="; # ogr-wps
  };

  oracle = mkGeoserverExtension {
    name = "oracle";
    version = "2.28.3"; # oracle
    hash = "sha256-fHbgYIz7Kb7lTgDVlKPkMwldXIJn/mqG3oHDUk76rTc="; # oracle
  };

  params-extractor = mkGeoserverExtension {
    name = "params-extractor";
    version = "2.28.3"; # params-extractor
    hash = "sha256-nseCXkh4V13FfbWtva79ydxg7sFMTeGrK3HygaVNPR8="; # params-extractor
  };

  printing = mkGeoserverExtension {
    name = "printing";
    version = "2.28.3"; # printing
    hash = "sha256-zGqDnmrO82cgCQgaorHa+O/Z5L42um/7CttZ2wC7Az4="; # printing
  };

  pyramid = mkGeoserverExtension {
    name = "pyramid";
    version = "2.28.3"; # pyramid
    hash = "sha256-BCvGhp9WmdqutPu09kIExJzuFGdOWQ8Eyin95iIhdw8="; # pyramid
  };

  querylayer = mkGeoserverExtension {
    name = "querylayer";
    version = "2.28.3"; # querylayer
    hash = "sha256-oA8F3J9i5sQTmUGLysddXF+GU6hR1yOHbNqiUAyPDTE="; # querylayer
  };

  sldservice = mkGeoserverExtension {
    name = "sldservice";
    version = "2.28.3"; # sldservice
    hash = "sha256-AehHS+ELScFdeZi5kyqqJ9nldKla06r8Yq1PB43cYA0="; # sldservice
  };

  sqlserver = mkGeoserverExtension {
    name = "sqlserver";
    version = "2.28.3"; # sqlserver
    hash = "sha256-ZS5ThHv/TEiH4BWcox68GKbqueFq7qhWDtDMgcUBINo="; # sqlserver
  };

  vectortiles = mkGeoserverExtension {
    name = "vectortiles";
    version = "2.28.3"; # vectortiles
    hash = "sha256-vvZSFfKgAFFtzLKv+RVh99frUyG2RkWrCwfR7scF+xw="; # vectortiles
  };

  wcs2_0-eo = mkGeoserverExtension {
    name = "wcs2_0-eo";
    version = "2.28.3"; # wcs2_0-eo
    hash = "sha256-x876KCXUbr1kGkAoHtDhoNqFGFVWw3te0tBt+03+ywU="; # wcs2_0-eo
  };

  web-resource = mkGeoserverExtension {
    name = "web-resource";
    version = "2.28.3"; # web-resource
    hash = "sha256-gjeqIP0qGCjogDgxug3k+1daVCxKQeHAsEJJWmPbe/8="; # web-resource
  };

  wmts-multi-dimensional = mkGeoserverExtension {
    name = "wmts-multi-dimensional";
    version = "2.28.3"; # wmts-multi-dimensional
    hash = "sha256-LbdMCDHjCiWpEUxL43RZY19a5DfJ9RKxmcq213NbAY8="; # wmts-multi-dimensional
  };

  wps = mkGeoserverExtension {
    name = "wps";
    version = "2.28.3"; # wps
    hash = "sha256-QgDpKbRGwGnAVrx/PW87N22D2yhrmzfg6qNmevXWI44="; # wps
  };

  # Needs hazelcast (https://github.com/hazelcast/hazelcast (?)) which is not
  # available in nixpgs as of 2024/01.
  #wps-cluster-hazelcast = mkGeoserverExtension {
  #  name = "wps-cluster-hazelcast";
  #  version = "2.28.3"; # wps-cluster-hazelcast
  #  hash = "sha256-beSIkj3btLokQsS800vD0q2hiagLnnX+VTH8DMQy8NI="; # wps-cluster-hazelcast
  #};

  wps-download = mkGeoserverExtension {
    name = "wps-download";
    version = "2.28.3"; # wps-download
    hash = "sha256-2dIjMPA8Y3sPzJLtPxX0HFuq+dYxmz65dJzxugkSyS0="; # wps-download
  };

  # Needs Postrgres configuration or similar.
  # See https://docs.geoserver.org/main/en/user/extensions/wps-jdbc/index.html
  wps-jdbc = mkGeoserverExtension {
    name = "wps-jdbc";
    version = "2.28.3"; # wps-jdbc
    hash = "sha256-yL5xw1g2FcWCSgfw28gbYmrvIiHD0coE9AAH601Bqbg="; # wps-jdbc
  };

  ysld = mkGeoserverExtension {
    name = "ysld";
    version = "2.28.3"; # ysld
    hash = "sha256-oe/eT/IdqnlrQ58HBpuQA6ZRw8oCPAWPQ2Tles71V8M="; # ysld
  };

}
