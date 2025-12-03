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
    version = "2.27.2"; # app-schema
    hash = "sha256-XJbuRdqvkusT1hZEuFoogTEB8vHOsX9cQxA0Mzhg1+8="; # app-schema
  };

  authkey = mkGeoserverExtension {
    name = "authkey";
    version = "2.27.2"; # authkey
    hash = "sha256-e43HG4iPgj9vj7lq0c9ATmWVumqHdtM9DrAwbQJqUcg="; # authkey
  };

  cas = mkGeoserverExtension {
    name = "cas";
    version = "2.27.2"; # cas
    hash = "sha256-kDYC8z5sRAycw6ZCKJ105XoYF5/ss4YTguqQ8pbnJls="; # cas
  };

  charts = mkGeoserverExtension {
    name = "charts";
    version = "2.27.2"; # charts
    hash = "sha256-zI+F21bQHcE4Lbh26bHeCTjTRJdswkUmmz+qAsP2t4k="; # charts
  };

  control-flow = mkGeoserverExtension {
    name = "control-flow";
    version = "2.27.2"; # control-flow
    hash = "sha256-5XW3l9MFEUeYuhOKqN4EqjwpRlMc8P8Tn46A2Z89Jks="; # control-flow
  };

  css = mkGeoserverExtension {
    name = "css";
    version = "2.27.2"; # css
    hash = "sha256-1fpP70Ed4iUrUyMMiMFhkykuPCzBV5+lWFicl9sUjAg="; # css
  };

  csw = mkGeoserverExtension {
    name = "csw";
    version = "2.27.2"; # csw
    hash = "sha256-4BYSY6tldkjd8KDlM/D+MNb9I8Ji0CVjyJcsBzRxC1Y="; # csw
  };

  csw-iso = mkGeoserverExtension {
    name = "csw-iso";
    version = "2.27.2"; # csw-iso
    hash = "sha256-/0soY61A1d4yKJolRtymoFOsKf42B/RacUSUqN/7uXo="; # csw-iso
  };

  db2 = mkGeoserverExtension {
    name = "db2";
    version = "2.27.2"; # db2
    hash = "sha256-agZZHkwAx5YTOCzDlhpiTWxBTyhAoIW1BgW3QfV/kug="; # db2
  };

  # Needs wps extension.
  dxf = mkGeoserverExtension {
    name = "dxf";
    version = "2.27.2"; # dxf
    hash = "sha256-F93QOpe0nBQDD+8iDnenacNJ87h+jCqytJ3uz7weCcg="; # dxf
  };

  excel = mkGeoserverExtension {
    name = "excel";
    version = "2.27.2"; # excel
    hash = "sha256-CYW9JBhDOLqxNKnlxNDy03sZzmGPLn9KaK4LScGMIIg="; # excel
  };

  feature-pregeneralized = mkGeoserverExtension {
    name = "feature-pregeneralized";
    version = "2.27.2"; # feature-pregeneralized
    hash = "sha256-0MuzhZ8Y/yy/AJ6vTvfJxXPgnf+fTJPfB8wNTboYHOw="; # feature-pregeneralized
  };

  # Note: The extension name ("gdal") clashes with pkgs.gdal.
  gdal = mkGeoserverExtension {
    name = "gdal";
    version = "2.27.2"; # gdal
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-Krdj96ddLsrA8J6B8ap3BBBe/+flVX7/GJRLN4UnKiY="; # gdal
  };

  # Throws "java.io.FileNotFoundException: URL [jar:file:/nix/store/.../WEB-INF/lib/gs-geofence-server-2.24.1.jar!/geofence-default-override.properties] cannot be resolved to absolute file path because it does not reside in the file system: jar:file:/nix/store/.../WEB-INF/lib/gs-geofence-server-2.24.1.jar!/geofence-default-override.properties" but seems to work out of the box.
  #geofence = mkGeoserverExtension {
  #  name = "geofence";
  #  version = "2.27.2"; # geofence
  #  hash = "sha256-Rzi8oZFy+SglTuPSYBFi/Wge4pOVY5yE50c8+jRI+4Y="; # geofence
  #};

  #geofence-server = mkGeoserverExtension {
  #  name = "geofence-server";
  #  version = "2.27.2"; # geofence-server
  #  hash = ""; # geofence-server
  #};

  #geofence-wps = mkGeoserverExtension {
  #  name = "geofence-wps";
  #  version = "2.27.2"; # geofence-wps
  #  hash = "sha256-dry787XPCVBPi4TXKyFL85QZwX0WdWfiXqz/yriMiWc="; # geofence-wps
  #};

  geopkg-output = mkGeoserverExtension {
    name = "geopkg-output";
    version = "2.27.2"; # geopkg-output
    hash = "sha256-LlYjYTa0mjOh+q2ILJORTAUlWy3mW9lEMd1vUyyhDV8="; # geopkg-output
  };

  grib = mkGeoserverExtension {
    name = "grib";
    version = "2.27.2"; # grib
    hash = "sha256-/OBhwToUuJfDcRnx4aJbXDb6HdGGtM8SCkjmFgfX65s="; # grib
    buildInputs = [ netcdf ];
  };

  gwc-s3 = mkGeoserverExtension {
    name = "gwc-s3";
    version = "2.27.2"; # gwc-s3
    hash = "sha256-A0I2/+pRuvcXCVduTNn/e1nDZnNkt7cKtPNNO3Yo8Bk="; # gwc-s3
  };

  h2 = mkGeoserverExtension {
    name = "h2";
    version = "2.27.2"; # h2
    hash = "sha256-kGXqb5xH4Jn6nhN8nfhldUcHtQodBUp9y3bviPim1Ak="; # h2
  };

  iau = mkGeoserverExtension {
    name = "iau";
    version = "2.27.2"; # iau
    hash = "sha256-KVkpQ92cvmc3nIsBygUU58vsIY8BZXEEXQrUeH/eEyM="; # iau
  };

  importer = mkGeoserverExtension {
    name = "importer";
    version = "2.27.2"; # importer
    hash = "sha256-Sumh9148zqwLCbpiknwLyVpxqufkoizMgszy//qC5dA="; # importer
  };

  inspire = mkGeoserverExtension {
    name = "inspire";
    version = "2.27.2"; # inspire
    hash = "sha256-IDX93Cu7BgrkmI5QcdYu++XzVwHOeCM17eXgqhDPSRQ="; # inspire
  };

  # Needs Kakadu plugin from
  # https://github.com/geosolutions-it/imageio-ext
  #jp2k = mkGeoserverExtension {
  #  name = "jp2k";
  #  version = "2.27.2"; # jp2k
  #  hash = "sha256-Ar+mVXZqYfP6OGISdRzBntWRo2msL5RN44bgPeMOqQw="; # jp2k
  #};

  libjpeg-turbo = mkGeoserverExtension {
    name = "libjpeg-turbo";
    version = "2.27.2"; # libjpeg-turbo
    hash = "sha256-6e9Bdy/Lh7ZXPzHVGX/f/qa53v1JWrUshlrtcziIbQs="; # libjpeg-turbo
    buildInputs = [ libjpeg.out ];
  };

  mapml = mkGeoserverExtension {
    name = "mapml";
    version = "2.27.2"; # mapml
    hash = "sha256-QTAoesynmxv+9bYwak6jat6J3In5ULdsy2ozjMbsoXI="; # mapml
  };

  mbstyle = mkGeoserverExtension {
    name = "mbstyle";
    version = "2.27.2"; # mbstyle
    hash = "sha256-zKdX77zy72lkMB928XIjU0pYZ7zFVEI7OfbJ2ozFIHk="; # mbstyle
  };

  metadata = mkGeoserverExtension {
    name = "metadata";
    version = "2.27.2"; # metadata
    hash = "sha256-VLBuqh9qfcv2BRHhjF1tAc6ACCOUPQcY4Yc0Vko/2l0="; # metadata
  };

  mongodb = mkGeoserverExtension {
    name = "mongodb";
    version = "2.27.2"; # mongodb
    hash = "sha256-xXgiOEMQhPbw6GorrkEiyV7isgmSuimzT/LK41c0bzA="; # mongodb
  };

  monitor = mkGeoserverExtension {
    name = "monitor";
    version = "2.27.2"; # monitor
    hash = "sha256-1x+Rz8wXl3cAsX5rHgMEe1+h17QS7PDBJGDFmKf+SMY="; # monitor
  };

  mysql = mkGeoserverExtension {
    name = "mysql";
    version = "2.27.2"; # mysql
    hash = "sha256-mmquP4u3YqqbGVK2jkbNtGiqVMENCThpRTWOz6f74Pk="; # mysql
  };

  netcdf = mkGeoserverExtension {
    name = "netcdf";
    version = "2.27.2"; # netcdf
    hash = "sha256-GhPde3Fw04lutbgPmDyxO/C7wkZO1ttASqqj2g6JuCM="; # netcdf
    buildInputs = [ netcdf ];
  };

  netcdf-out = mkGeoserverExtension {
    name = "netcdf-out";
    version = "2.27.2"; # netcdf-out
    hash = "sha256-r4CyrlRm04tE3+vJfF+KlHAczrOy+dsTHXBG++GG0ys="; # netcdf-out
    buildInputs = [ netcdf ];
  };

  ogr-wfs = mkGeoserverExtension {
    name = "ogr-wfs";
    version = "2.27.2"; # ogr-wfs
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-EI0FNYFwcmsLYiYauvCAvweAIn6bI7WaCVPcCtkGrys="; # ogr-wfs
  };

  # Needs ogr-wfs extension.
  ogr-wps = mkGeoserverExtension {
    name = "ogr-wps";
    version = "2.27.2"; # ogr-wps
    # buildInputs = [ pkgs.gdal ];
    hash = "sha256-CtsaQg9IZxlRW4oQwmdBA+VLWtsNP3+jS1Mj2RxAJw4="; # ogr-wps
  };

  oracle = mkGeoserverExtension {
    name = "oracle";
    version = "2.27.2"; # oracle
    hash = "sha256-8cRDvWWFJHZZGmbZEruvp1whfhXZ/c7TYha4Fa5DuzM="; # oracle
  };

  params-extractor = mkGeoserverExtension {
    name = "params-extractor";
    version = "2.27.2"; # params-extractor
    hash = "sha256-Y7tt0F//dANcKds/mU6702S5PMJNVLcxxc+hYFNOt5M="; # params-extractor
  };

  printing = mkGeoserverExtension {
    name = "printing";
    version = "2.27.2"; # printing
    hash = "sha256-I5vVlpX2kXof3wuyRs2QvhWdx0Okm7StYvY8I/AL8Ug="; # printing
  };

  pyramid = mkGeoserverExtension {
    name = "pyramid";
    version = "2.27.2"; # pyramid
    hash = "sha256-/iIwS5iw95qotmmLWGU11br36dVc+o5LmwTDXBL7zaY="; # pyramid
  };

  querylayer = mkGeoserverExtension {
    name = "querylayer";
    version = "2.27.2"; # querylayer
    hash = "sha256-G66AkPkytzXvEi9hbudvBphFKrvMrhUbPSVvexXRJh4="; # querylayer
  };

  sldservice = mkGeoserverExtension {
    name = "sldservice";
    version = "2.27.2"; # sldservice
    hash = "sha256-djERawjM06NtZK6RnNh/qIS/x5ZjSWeUMHlUSF4/5aA="; # sldservice
  };

  sqlserver = mkGeoserverExtension {
    name = "sqlserver";
    version = "2.27.2"; # sqlserver
    hash = "sha256-Kad2wJmN/67xlLDViFfYWxvsSjmW+j3/iQEAvwEMZW4="; # sqlserver
  };

  vectortiles = mkGeoserverExtension {
    name = "vectortiles";
    version = "2.27.2"; # vectortiles
    hash = "sha256-S5ujjj8JLXbybbjpA8qLF4sapVIECDZ8l+iqqUoVHuc="; # vectortiles
  };

  wcs2_0-eo = mkGeoserverExtension {
    name = "wcs2_0-eo";
    version = "2.27.2"; # wcs2_0-eo
    hash = "sha256-S2d3Yel0B0DJubuMUywPB2gDiWIpdkniDksZcq8j9BI="; # wcs2_0-eo
  };

  web-resource = mkGeoserverExtension {
    name = "web-resource";
    version = "2.27.2"; # web-resource
    hash = "sha256-HJ+GPrprrCPlzh9q+PZr0QEJE/YVXaqgxhUlYHPkgho="; # web-resource
  };

  wmts-multi-dimensional = mkGeoserverExtension {
    name = "wmts-multi-dimensional";
    version = "2.27.2"; # wmts-multi-dimensional
    hash = "sha256-de+0UEsRJyl9plnmOaWSI8xNc6RG+U7uJVEyvgwng4Q="; # wmts-multi-dimensional
  };

  wps = mkGeoserverExtension {
    name = "wps";
    version = "2.27.2"; # wps
    hash = "sha256-Fn0XWncwqUmMub9eBxb5GN2cc3eMdyB55NB9AUvVQpQ="; # wps
  };

  # Needs hazelcast (https://github.com/hazelcast/hazelcast (?)) which is not
  # available in nixpgs as of 2024/01.
  #wps-cluster-hazelcast = mkGeoserverExtension {
  #  name = "wps-cluster-hazelcast";
  #  version = "2.27.2"; # wps-cluster-hazelcast
  #  hash = "sha256-xV6JddIC5Uq8H3RaE9tqCMK+5OA5WrXfh6O82BVw+P0="; # wps-cluster-hazelcast
  #};

  wps-download = mkGeoserverExtension {
    name = "wps-download";
    version = "2.27.2"; # wps-download
    hash = "sha256-loP1oYqie2U00RWOwlLzprECfnBTG2MeJNhPZJx8Q1o="; # wps-download
  };

  # Needs Postrgres configuration or similar.
  # See https://docs.geoserver.org/main/en/user/extensions/wps-jdbc/index.html
  wps-jdbc = mkGeoserverExtension {
    name = "wps-jdbc";
    version = "2.27.2"; # wps-jdbc
    hash = "sha256-LpxGscFx7DCeM90VGs4lAMoKNXJVDnSCptdC9VeeU/o="; # wps-jdbc
  };

  ysld = mkGeoserverExtension {
    name = "ysld";
    version = "2.27.2"; # ysld
    hash = "sha256-1yOaJcPyLOm/lYdOazHU5DjfahSjuN00yYvxgsE5RKM="; # ysld
  };

}
