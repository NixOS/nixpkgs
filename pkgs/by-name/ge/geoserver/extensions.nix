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
        url = "mirror://sourceforge/geoserver/GeoServer/${version}/extensions/geoserver-${version}-${name}-plugin.zip";
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
    version = "2.28.1"; # app-schema
    hash = "sha256-PwZW9hFRiZIxgil75DXMsq0ymo7jPYX4Boj+hkXW8NI="; # app-schema
  };

  authkey = mkGeoserverExtension {
    name = "authkey";
    version = "2.28.1"; # authkey
    hash = "sha256-Zg3Db5QG4w+yMZ75MqtHt1Kri8peDGMZ0va5ZwI+6dw="; # authkey
  };

  cas = mkGeoserverExtension {
    name = "cas";
    version = "2.28.1"; # cas
    hash = "sha256-YMnaRVPLn98mXm2sErKSRlzmvQbnU9MGMDXuYgwm+H0="; # cas
  };

  charts = mkGeoserverExtension {
    name = "charts";
    version = "2.28.1"; # charts
    hash = "sha256-LM75iq2xvSQjVxGnngoLCz5IkSI9/YqAqOqgSUlkrUA="; # charts
  };

  control-flow = mkGeoserverExtension {
    name = "control-flow";
    version = "2.28.1"; # control-flow
    hash = "sha256-ZO04mls+OapOK/fi5IBy0mVJ5cF0fyQ1RgFhWt0AuEw="; # control-flow
  };

  css = mkGeoserverExtension {
    name = "css";
    version = "2.28.1"; # css
    hash = "sha256-2PcZhxkHXEOAs46fnt37VhupVOfRNWaRynNlLGviAho="; # css
  };

  csw = mkGeoserverExtension {
    name = "csw";
    version = "2.28.1"; # csw
    hash = "sha256-6TmSWnny0OedvnLu+HnKpVxdfcicp1D//isFFOclcmk="; # csw
  };

  csw-iso = mkGeoserverExtension {
    name = "csw-iso";
    version = "2.28.1"; # csw-iso
    hash = "sha256-BlnIS8gpWwBuiwdIqvq3UpJrdKPULvJxR7o3XJtI5tQ="; # csw-iso
  };

  db2 = mkGeoserverExtension {
    name = "db2";
    version = "2.28.1"; # db2
    hash = "sha256-Ga4Db6G+LxRN+casjs0nYD6TFN1YrDjgOIlu46/0RgQ="; # db2
  };

  # Needs wps extension.
  dxf = mkGeoserverExtension {
    name = "dxf";
    version = "2.28.1"; # dxf
    hash = "sha256-703y8CBd9oYsryGgAftXq5Cr1lUeyws1Alx0tSwzZo8="; # dxf
  };

  excel = mkGeoserverExtension {
    name = "excel";
    version = "2.28.1"; # excel
    hash = "sha256-9ti+J7e9QieVbCFQ2xxuqX8TvQCcLPw0tPUNVqGG9+0="; # excel
  };

  feature-pregeneralized = mkGeoserverExtension {
    name = "feature-pregeneralized";
    version = "2.28.1"; # feature-pregeneralized
    hash = "sha256-eGayG9FUJabhP60iypib1gLcRStqz5J4PMTuSB+xL60="; # feature-pregeneralized
  };

  # Note: The extension name ("gdal") clashes with pkgs.gdal.
  gdal = mkGeoserverExtension {
    name = "gdal";
    version = "2.28.1"; # gdal
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-sVI9o2xwbvez7Gm8gY9DAbEr5TUluVGDoC7ZweK4BUE="; # gdal
  };

  # Throws "java.io.FileNotFoundException: URL [jar:file:/nix/store/.../WEB-INF/lib/gs-geofence-server-2.24.1.jar!/geofence-default-override.properties] cannot be resolved to absolute file path because it does not reside in the file system: jar:file:/nix/store/.../WEB-INF/lib/gs-geofence-server-2.24.1.jar!/geofence-default-override.properties" but seems to work out of the box.
  #geofence = mkGeoserverExtension {
  #  name = "geofence";
  #  version = "2.28.1"; # geofence
  #  hash = "sha256-POBOhg3d8HlA3qF2W41UTVhISM5vAQi74cI+y+Rj+Ic="; # geofence
  #};

  #geofence-server = mkGeoserverExtension {
  #  name = "geofence-server";
  #  version = "2.28.1"; # geofence-server
  #  hash = ""; # geofence-server
  #};

  #geofence-wps = mkGeoserverExtension {
  #  name = "geofence-wps";
  #  version = "2.28.1"; # geofence-wps
  #  hash = "sha256-tP3hnN0kXKFIdgKrS7juyrCh1OoQD0Bx54/xq6nUzWA="; # geofence-wps
  #};

  geopkg-output = mkGeoserverExtension {
    name = "geopkg-output";
    version = "2.28.1"; # geopkg-output
    hash = "sha256-6ARKLmhc5lhqi841Ou5ZrBuj6bdOwQDSGPwzGcBTNJw="; # geopkg-output
  };

  grib = mkGeoserverExtension {
    name = "grib";
    version = "2.28.1"; # grib
    hash = "sha256-AW/i+vRthQct3U45EGw/6uPDZNdS9z816nnKVIGCg/k="; # grib
    buildInputs = [ netcdf ];
  };

  gwc-s3 = mkGeoserverExtension {
    name = "gwc-s3";
    version = "2.28.1"; # gwc-s3
    hash = "sha256-wVLW7qbKDRmf1okTI0PDREQ5eoJOVGMVLS+uusY2+cM="; # gwc-s3
  };

  h2 = mkGeoserverExtension {
    name = "h2";
    version = "2.28.1"; # h2
    hash = "sha256-zEjNN1dCmNR/5st/yNpWP1G3P6Zqf3RSFdUKOgdwff4="; # h2
  };

  iau = mkGeoserverExtension {
    name = "iau";
    version = "2.28.1"; # iau
    hash = "sha256-zn4FlC/vVvq1K6mSplOKarHHUWLNev5IW76wSiTvBuE="; # iau
  };

  importer = mkGeoserverExtension {
    name = "importer";
    version = "2.28.1"; # importer
    hash = "sha256-7v5MvpvVbVKOBxUlEwem8MzPUTtBc8z+1JAEqeHUmYI="; # importer
  };

  inspire = mkGeoserverExtension {
    name = "inspire";
    version = "2.28.1"; # inspire
    hash = "sha256-kgqwO3elSnT/4M9G+OgULaW+i/nDNGhvHblmWZRjTTA="; # inspire
  };

  # Needs Kakadu plugin from
  # https://github.com/geosolutions-it/imageio-ext
  #jp2k = mkGeoserverExtension {
  #  name = "jp2k";
  #  version = "2.28.1"; # jp2k
  #  hash = "sha256-sLUgsMXymnTuceCRLzqIAPmk4/Q3BO+A+7BLQoc3iP0="; # jp2k
  #};

  libjpeg-turbo = mkGeoserverExtension {
    name = "libjpeg-turbo";
    version = "2.28.1"; # libjpeg-turbo
    hash = "sha256-fn1ItYvLMfvRLpCE8rEpTpBmkk8zkN3QtBO/RN4RXfo="; # libjpeg-turbo
    buildInputs = [ libjpeg.out ];
  };

  mapml = mkGeoserverExtension {
    name = "mapml";
    version = "2.28.1"; # mapml
    hash = "sha256-AonH/wBRh0oVs8psJ+XRutkSwybN3fs505SI/0qzG3o="; # mapml
  };

  mbstyle = mkGeoserverExtension {
    name = "mbstyle";
    version = "2.28.1"; # mbstyle
    hash = "sha256-SvgvBkp6dS6v1JjQxpa7m7tqc2c63hruWCcFcouHXaQ="; # mbstyle
  };

  metadata = mkGeoserverExtension {
    name = "metadata";
    version = "2.28.1"; # metadata
    hash = "sha256-M3HcgrPGZBBotNm6dsw4UjrH1onIQHDMdxuwNVuqO84="; # metadata
  };

  mongodb = mkGeoserverExtension {
    name = "mongodb";
    version = "2.28.1"; # mongodb
    hash = "sha256-Urp8d0i6Xlk2muNKKioJTnrEvzC05tqiipLT162L7uk="; # mongodb
  };

  monitor = mkGeoserverExtension {
    name = "monitor";
    version = "2.28.1"; # monitor
    hash = "sha256-Qo9aFOjbg9s1RZVqa/z1ka+QmFrPZJgrH8qMcstCywQ="; # monitor
  };

  mysql = mkGeoserverExtension {
    name = "mysql";
    version = "2.28.1"; # mysql
    hash = "sha256-5/xP8vPNhOYN9YXL4sZk16652ZBB7Ivm7Cq05fYi7wI="; # mysql
  };

  netcdf = mkGeoserverExtension {
    name = "netcdf";
    version = "2.28.1"; # netcdf
    hash = "sha256-qKgSyFrKI7JVMNt/qjgJ5puLaTsU406P5VyUpncMHOg="; # netcdf
    buildInputs = [ netcdf ];
  };

  netcdf-out = mkGeoserverExtension {
    name = "netcdf-out";
    version = "2.28.1"; # netcdf-out
    hash = "sha256-Xk3cTve45U9LDv8lWugtGpfid4yr5yDWh7H7daVlAc8="; # netcdf-out
    buildInputs = [ netcdf ];
  };

  ogr-wfs = mkGeoserverExtension {
    name = "ogr-wfs";
    version = "2.28.1"; # ogr-wfs
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-ykFfqoLXeGigAdCLnDCKiCGD++n7jiOivua8Oh2DwU8="; # ogr-wfs
  };

  # Needs ogr-wfs extension.
  ogr-wps = mkGeoserverExtension {
    name = "ogr-wps";
    version = "2.28.1"; # ogr-wps
    # buildInputs = [ pkgs.gdal ];
    hash = "sha256-WxOZ5WDNxV1HAT9cfCPm9DwoU/96OobuODOjd5dGN94="; # ogr-wps
  };

  oracle = mkGeoserverExtension {
    name = "oracle";
    version = "2.28.1"; # oracle
    hash = "sha256-lj53CC6f9vXatH9vxHaFZvEGDpplTZSYy56fz4d4Qs0="; # oracle
  };

  params-extractor = mkGeoserverExtension {
    name = "params-extractor";
    version = "2.28.1"; # params-extractor
    hash = "sha256-1Znwqb+PHFlsuQIs8pMqo08s4uSc7wLZRYE+hVZzoQY="; # params-extractor
  };

  printing = mkGeoserverExtension {
    name = "printing";
    version = "2.28.1"; # printing
    hash = "sha256-OeMHkx4d7/FwNigQ8Mnz9UlqFJbMZFGmxZT8kJ3iPp8="; # printing
  };

  pyramid = mkGeoserverExtension {
    name = "pyramid";
    version = "2.28.1"; # pyramid
    hash = "sha256-fLe2SeRSNvj6qqh6CMDu2w0gubf+xi3Ez7jO2fEbpjc="; # pyramid
  };

  querylayer = mkGeoserverExtension {
    name = "querylayer";
    version = "2.28.1"; # querylayer
    hash = "sha256-QM5DAoTFsn6JTLubQy4p0qsA91DcfU7C74cb80jzzWM="; # querylayer
  };

  sldservice = mkGeoserverExtension {
    name = "sldservice";
    version = "2.28.1"; # sldservice
    hash = "sha256-u5uzwyrwBzz5qcEtRS+ZIbmis9kVuGPt6+qo19K1HCM="; # sldservice
  };

  sqlserver = mkGeoserverExtension {
    name = "sqlserver";
    version = "2.28.1"; # sqlserver
    hash = "sha256-19KyMBZEYBeUKiogxux8jrc8VgNDdCnvhrEV8Q84SG0="; # sqlserver
  };

  vectortiles = mkGeoserverExtension {
    name = "vectortiles";
    version = "2.28.1"; # vectortiles
    hash = "sha256-tT4phUdL8yMKzobxWNivMpHJYu6KQmPiNECK9TtJgjg="; # vectortiles
  };

  wcs2_0-eo = mkGeoserverExtension {
    name = "wcs2_0-eo";
    version = "2.28.1"; # wcs2_0-eo
    hash = "sha256-HawDOyymB01x7PaFg5QKQhTSFdybeY5oAAusaG95To8="; # wcs2_0-eo
  };

  web-resource = mkGeoserverExtension {
    name = "web-resource";
    version = "2.28.1"; # web-resource
    hash = "sha256-FkuxR3WN95jyorpcv4ShT9J6jmUi0Z9NNwLEW3OKzx0="; # web-resource
  };

  wmts-multi-dimensional = mkGeoserverExtension {
    name = "wmts-multi-dimensional";
    version = "2.28.1"; # wmts-multi-dimensional
    hash = "sha256-tJP9pPKKYFLGbLWZEV5gWSaQdTbml3OKiIPM1sqhekY="; # wmts-multi-dimensional
  };

  wps = mkGeoserverExtension {
    name = "wps";
    version = "2.28.1"; # wps
    hash = "sha256-aYAN89XFpwzsW5aRBKSnixks3bxCAfOOznFDpoIvbIk="; # wps
  };

  # Needs hazelcast (https://github.com/hazelcast/hazelcast (?)) which is not
  # available in nixpgs as of 2024/01.
  #wps-cluster-hazelcast = mkGeoserverExtension {
  #  name = "wps-cluster-hazelcast";
  #  version = "2.28.1"; # wps-cluster-hazelcast
  #  hash = "sha256-hO1/7OG9J5Ot5xKhMUbTAqm7B6TlecqNGxxbIuFCpCc="; # wps-cluster-hazelcast
  #};

  wps-download = mkGeoserverExtension {
    name = "wps-download";
    version = "2.28.1"; # wps-download
    hash = "sha256-qB1vtczNULOsEjZaof9cA5YKPDE0Dwcz6mlUtzCanPQ="; # wps-download
  };

  # Needs Postrgres configuration or similar.
  # See https://docs.geoserver.org/main/en/user/extensions/wps-jdbc/index.html
  wps-jdbc = mkGeoserverExtension {
    name = "wps-jdbc";
    version = "2.28.1"; # wps-jdbc
    hash = "sha256-9S6/TXK9YFzPD8u/S7SQuBcIGjUTalY69kzG4xbIU3g="; # wps-jdbc
  };

  ysld = mkGeoserverExtension {
    name = "ysld";
    version = "2.28.1"; # ysld
    hash = "sha256-qLWnujvB32U0EW7xW12GaAx6mPHkrU5Pa3S+T8+19r8="; # ysld
  };

}
