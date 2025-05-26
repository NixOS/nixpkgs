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
    version = "2.27.0"; # app-schema
    hash = "sha256-S7WtIbmn9RF0mmTRiOH5zFsjZ6y0mvVu0H8jKCdTPHM="; # app-schema
  };

  authkey = mkGeoserverExtension {
    name = "authkey";
    version = "2.27.0"; # authkey
    hash = "sha256-GwA/f5wMf701TEs04Dgx/zcEA/jBHgw0JuJMKqTuRTU="; # authkey
  };

  cas = mkGeoserverExtension {
    name = "cas";
    version = "2.27.0"; # cas
    hash = "sha256-poD8OBeR7txtM1nJDy5MV6GVREVonLvx3TUY3a1V2Mc="; # cas
  };

  charts = mkGeoserverExtension {
    name = "charts";
    version = "2.27.0"; # charts
    hash = "sha256-8FoaN9EoFZ56YPev//IphMjce1iJQnMbP6xCdVSwMiU="; # charts
  };

  control-flow = mkGeoserverExtension {
    name = "control-flow";
    version = "2.27.0"; # control-flow
    hash = "sha256-DyZp/dcRm/xuvxv49qvepcDJPyHGiG4wMbEzKNhNcH0="; # control-flow
  };

  css = mkGeoserverExtension {
    name = "css";
    version = "2.27.0"; # css
    hash = "sha256-PKRgGbDlTjrFkhrDpbjDjAl+Q/gjWXFw9C0QpKB8+Ro="; # css
  };

  csw = mkGeoserverExtension {
    name = "csw";
    version = "2.27.0"; # csw
    hash = "sha256-sddOghBd8OVjKmaF3PqM/G+RkpsUk6vmCZv7uQJTJnU="; # csw
  };

  csw-iso = mkGeoserverExtension {
    name = "csw-iso";
    version = "2.27.0"; # csw-iso
    hash = "sha256-WVKVoQWIusgpAZUWPybBBIMbtWB56uNix3T50hy0x5w="; # csw-iso
  };

  db2 = mkGeoserverExtension {
    name = "db2";
    version = "2.27.0"; # db2
    hash = "sha256-jlyRGOGBFJ0+sArKXqchITlS6swE/v4ScdxPKWANFaE="; # db2
  };

  # Needs wps extension.
  dxf = mkGeoserverExtension {
    name = "dxf";
    version = "2.27.0"; # dxf
    hash = "sha256-hdn5X7T5/H7Ti0UK3MdG0TFGInwu7S7Z4VghcWx+hdQ="; # dxf
  };

  excel = mkGeoserverExtension {
    name = "excel";
    version = "2.27.0"; # excel
    hash = "sha256-EH1TZeYPk+sb9+7ZfjbaEsNgQJ+/57XCc2+CvELsY88="; # excel
  };

  feature-pregeneralized = mkGeoserverExtension {
    name = "feature-pregeneralized";
    version = "2.27.0"; # feature-pregeneralized
    hash = "sha256-0389xo0NjTREGQLMrqJesl/XrFOrjFjjFBL7GSUMl/Y="; # feature-pregeneralized
  };

  # Note: The extension name ("gdal") clashes with pkgs.gdal.
  gdal = mkGeoserverExtension {
    name = "gdal";
    version = "2.27.0"; # gdal
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-oTSEk+AmgXydSF4TZD9m5ViyeWh5HpAprMZAPMdP2LI="; # gdal
  };

  # Throws "java.io.FileNotFoundException: URL [jar:file:/nix/store/.../WEB-INF/lib/gs-geofence-server-2.24.1.jar!/geofence-default-override.properties] cannot be resolved to absolute file path because it does not reside in the file system: jar:file:/nix/store/.../WEB-INF/lib/gs-geofence-server-2.24.1.jar!/geofence-default-override.properties" but seems to work out of the box.
  #geofence = mkGeoserverExtension {
  #  name = "geofence";
  #  version = "2.27.0"; # geofence
  #  hash = "sha256-P7ZHvC4qv1meziqPmBfOgQ+Y06Ico0N1trUi9LMZUJQ="; # geofence
  #};

  #geofence-server = mkGeoserverExtension {
  #  name = "geofence-server";
  #  version = "2.27.0"; # geofence-server
  #  hash = ""; # geofence-server
  #};

  #geofence-wps = mkGeoserverExtension {
  #  name = "geofence-wps";
  #  version = "2.27.0"; # geofence-wps
  #  hash = "sha256-8Wvb/elunsYTFD1GgEQunM8i0eDyOA/W52KZ9+7uvvk="; # geofence-wps
  #};

  geopkg-output = mkGeoserverExtension {
    name = "geopkg-output";
    version = "2.27.0"; # geopkg-output
    hash = "sha256-VUqBTt0XfSY2Q8cfeCpVmr398PK+Sb74APSrBODJNlw="; # geopkg-output
  };

  grib = mkGeoserverExtension {
    name = "grib";
    version = "2.27.0"; # grib
    hash = "sha256-xX9LAgo5exeD2UxZ8/LROZWobLHLw33jcpwERGUGPys="; # grib
    buildInputs = [ netcdf ];
  };

  gwc-s3 = mkGeoserverExtension {
    name = "gwc-s3";
    version = "2.27.0"; # gwc-s3
    hash = "sha256-/koF00Rki1xiY/g4ahhvFZNQxGnvIbbnqNmYHBqArBI="; # gwc-s3
  };

  h2 = mkGeoserverExtension {
    name = "h2";
    version = "2.27.0"; # h2
    hash = "sha256-lfWu3812AMv0bB2dllNlcOSyN+IMASI/nkjLaStvUtw="; # h2
  };

  iau = mkGeoserverExtension {
    name = "iau";
    version = "2.27.0"; # iau
    hash = "sha256-9PhWejZILq1hcWBdvWh9SdtfLOlpFcaIU9TeJ8z7UUw="; # iau
  };

  importer = mkGeoserverExtension {
    name = "importer";
    version = "2.27.0"; # importer
    hash = "sha256-oqlNcUkO7XlcI6QQF+44kt69ZWtPSdcpyuA5xGtVrAQ="; # importer
  };

  inspire = mkGeoserverExtension {
    name = "inspire";
    version = "2.27.0"; # inspire
    hash = "sha256-irSJm3gDJAiDHczkS84OW+noOIryCOmSwiIU4GAKqoQ="; # inspire
  };

  # Needs Kakadu plugin from
  # https://github.com/geosolutions-it/imageio-ext
  #jp2k = mkGeoserverExtension {
  #  name = "jp2k";
  #  version = "2.27.0"; # jp2k
  #  hash = "sha256-WKWtNKv1sQrdrraCj9jmEODtIhCVF25HFbQNROdlyxg="; # jp2k
  #};

  libjpeg-turbo = mkGeoserverExtension {
    name = "libjpeg-turbo";
    version = "2.27.0"; # libjpeg-turbo
    hash = "sha256-tMov4w8Kfbrr7hkNK4o+XFUuenyidCem7Z36KXinfTE="; # libjpeg-turbo
    buildInputs = [ libjpeg.out ];
  };

  mapml = mkGeoserverExtension {
    name = "mapml";
    version = "2.27.0"; # mapml
    hash = "sha256-HONocKWnjkGqGRmtDxcJSwnDHwVouY6YeORRBjAbu4M="; # mapml
  };

  mbstyle = mkGeoserverExtension {
    name = "mbstyle";
    version = "2.27.0"; # mbstyle
    hash = "sha256-c1QijJj/WfbTxc4vM55lz+wx2PW4BY3tXneSM+3zXRA="; # mbstyle
  };

  metadata = mkGeoserverExtension {
    name = "metadata";
    version = "2.27.0"; # metadata
    hash = "sha256-5b9gtSzP9DOyhwoNdFVnv08WjlH+m0ZFPO+jqtbUJ1A="; # metadata
  };

  mongodb = mkGeoserverExtension {
    name = "mongodb";
    version = "2.27.0"; # mongodb
    hash = "sha256-Y9KQ7lqfCnPfTdPUzidi9wNZPeiTTqB+4lf5q7mSQ88="; # mongodb
  };

  monitor = mkGeoserverExtension {
    name = "monitor";
    version = "2.27.0"; # monitor
    hash = "sha256-uAkOudY7yACJ9A+FxcKSDUhGiID+uTvBibCejFwEiT0="; # monitor
  };

  mysql = mkGeoserverExtension {
    name = "mysql";
    version = "2.27.0"; # mysql
    hash = "sha256-qA3l9gx4AuqqbPHfQkbvJNYfURrBSnmq4S4nEPrFpO4="; # mysql
  };

  netcdf = mkGeoserverExtension {
    name = "netcdf";
    version = "2.27.0"; # netcdf
    hash = "sha256-3pxGeIWcsBnJMdZjupOR/GmglxYWJp8KjJsmZSCRK00="; # netcdf
    buildInputs = [ netcdf ];
  };

  netcdf-out = mkGeoserverExtension {
    name = "netcdf-out";
    version = "2.27.0"; # netcdf-out
    hash = "sha256-GfwJqdoO1Z265OmfAvjoKy0/DLX8e06Mu58o4Zps4q0="; # netcdf-out
    buildInputs = [ netcdf ];
  };

  ogr-wfs = mkGeoserverExtension {
    name = "ogr-wfs";
    version = "2.27.0"; # ogr-wfs
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-FX3sojRnR6FQSFSK4n62w/lrPbHTdbLn9NtR2nE/3dU="; # ogr-wfs
  };

  # Needs ogr-wfs extension.
  ogr-wps = mkGeoserverExtension {
    name = "ogr-wps";
    version = "2.27.0"; # ogr-wps
    # buildInputs = [ pkgs.gdal ];
    hash = "sha256-Nb7rkbZPw85+EAcR+ist4iW16HVfsH9cSYwplHyO4RY="; # ogr-wps
  };

  oracle = mkGeoserverExtension {
    name = "oracle";
    version = "2.27.0"; # oracle
    hash = "sha256-4KnZ48oKmgap3qZiJE4TSCQZpMvCQd4PULWponW5f1c="; # oracle
  };

  params-extractor = mkGeoserverExtension {
    name = "params-extractor";
    version = "2.27.0"; # params-extractor
    hash = "sha256-0NnL87Cn/DcLXTnBJhgcGHNmC6SYKRc7TY+4r7VcYJQ="; # params-extractor
  };

  printing = mkGeoserverExtension {
    name = "printing";
    version = "2.27.0"; # printing
    hash = "sha256-10uBc9ZI9M9m5vmKMXfB1TieJBr7cx/SeD1AiXNVJo8="; # printing
  };

  pyramid = mkGeoserverExtension {
    name = "pyramid";
    version = "2.27.0"; # pyramid
    hash = "sha256-K38fYjM0Oh+FHT5Wadjuc3KIhFP2x5q5cxW5aucZNNw="; # pyramid
  };

  querylayer = mkGeoserverExtension {
    name = "querylayer";
    version = "2.27.0"; # querylayer
    hash = "sha256-5OPfTUB0d08jWjxWd77BxffZgx+eM5eJX9bX0kt/WpM="; # querylayer
  };

  sldservice = mkGeoserverExtension {
    name = "sldservice";
    version = "2.27.0"; # sldservice
    hash = "sha256-rWIbWCsX4Hkank0L02sluTF137Y6Pex15Gobiwv2pNM="; # sldservice
  };

  sqlserver = mkGeoserverExtension {
    name = "sqlserver";
    version = "2.27.0"; # sqlserver
    hash = "sha256-ghf3z9b586RUgvicyOXlW2K8Uq9TolRb7CrcKT1Jt1M="; # sqlserver
  };

  vectortiles = mkGeoserverExtension {
    name = "vectortiles";
    version = "2.27.0"; # vectortiles
    hash = "sha256-ho/Vp1cFq2/xY9fIaQUR+vBQ6Vfdf+Z2eYvL7eI1qMY="; # vectortiles
  };

  wcs2_0-eo = mkGeoserverExtension {
    name = "wcs2_0-eo";
    version = "2.27.0"; # wcs2_0-eo
    hash = "sha256-GcoOT3JNQPUN8ETX4spJXteJvbNM9+YO85FH+dw3oSg="; # wcs2_0-eo
  };

  web-resource = mkGeoserverExtension {
    name = "web-resource";
    version = "2.27.0"; # web-resource
    hash = "sha256-4TGt9MklLWbJexY7kjT+ijIX/V4OLw7U6mDkBoVXuwk="; # web-resource
  };

  wmts-multi-dimensional = mkGeoserverExtension {
    name = "wmts-multi-dimensional";
    version = "2.27.0"; # wmts-multi-dimensional
    hash = "sha256-8I3XbAToqTgwf4y+C3ulAhCY7axyS739GV4+jxwO33g="; # wmts-multi-dimensional
  };

  wps = mkGeoserverExtension {
    name = "wps";
    version = "2.27.0"; # wps
    hash = "sha256-9OrjyVaf9JzDPXyqHqqg51aAllhcAf4bOvQQyV1dHpI="; # wps
  };

  # Needs hazelcast (https://github.com/hazelcast/hazelcast (?)) which is not
  # available in nixpgs as of 2024/01.
  #wps-cluster-hazelcast = mkGeoserverExtension {
  #  name = "wps-cluster-hazelcast";
  #  version = "2.27.0"; # wps-cluster-hazelcast
  #  hash = "sha256-amHfS5eBRoiMdj3wJzRNg9krYo5DJrCvCvhtj/Z9mUw="; # wps-cluster-hazelcast
  #};

  wps-download = mkGeoserverExtension {
    name = "wps-download";
    version = "2.27.0"; # wps-download
    hash = "sha256-vQpSGiOUh9N4PDQ4w/mTNjooz0lYDXwwRpZsq9VhEMA="; # wps-download
  };

  # Needs Postrgres configuration or similar.
  # See https://docs.geoserver.org/main/en/user/extensions/wps-jdbc/index.html
  wps-jdbc = mkGeoserverExtension {
    name = "wps-jdbc";
    version = "2.27.0"; # wps-jdbc
    hash = "sha256-YWBOLL3X6Ztv+9EWmHKd5N020+qkVNtXXbObSlBhp2s="; # wps-jdbc
  };

  ysld = mkGeoserverExtension {
    name = "ysld";
    version = "2.27.0"; # ysld
    hash = "sha256-fPF4LM0WC4YaAMnPhz3A/XXOoMu+v8TsO6XIcXHWRi4="; # ysld
  };

}
