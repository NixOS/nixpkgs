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
    version = "2.27.1"; # app-schema
    hash = "sha256-en9j/FhM7llsgvg26nIqqpt3wVJ9wtshkimMQ4bn1O4="; # app-schema
  };

  authkey = mkGeoserverExtension {
    name = "authkey";
    version = "2.27.1"; # authkey
    hash = "sha256-c2m5qfeeAlRoKl1ZgGzlURYivgUMh/22MBNXscKiRi8="; # authkey
  };

  cas = mkGeoserverExtension {
    name = "cas";
    version = "2.27.1"; # cas
    hash = "sha256-42ePZ90vATFsTkT9e2XaKM2uR05K5xUYbmwFPyQR4xk="; # cas
  };

  charts = mkGeoserverExtension {
    name = "charts";
    version = "2.27.1"; # charts
    hash = "sha256-y2N7/ZnxeiP0cNtLXMzN0jSIAGc8t1QzSLD1wEVa/LY="; # charts
  };

  control-flow = mkGeoserverExtension {
    name = "control-flow";
    version = "2.27.1"; # control-flow
    hash = "sha256-/Vv2otkJuaPAHxs7bZZ4UkB5tXR7YLb2Qn0eA5wRJkk="; # control-flow
  };

  css = mkGeoserverExtension {
    name = "css";
    version = "2.27.1"; # css
    hash = "sha256-ZQtyljZuQdX7fS+4oGALXZBsscr8M6m1hgAN0EoBRVM="; # css
  };

  csw = mkGeoserverExtension {
    name = "csw";
    version = "2.27.1"; # csw
    hash = "sha256-P0PMs8JNxHXwPy610mYc9Fz6uO+LnYWm7fd8i2R3vTY="; # csw
  };

  csw-iso = mkGeoserverExtension {
    name = "csw-iso";
    version = "2.27.1"; # csw-iso
    hash = "sha256-aQCFUTQeTx+RuBjXksq3guHQ+LIaA3RCSLv9XQ9BdtA="; # csw-iso
  };

  db2 = mkGeoserverExtension {
    name = "db2";
    version = "2.27.1"; # db2
    hash = "sha256-RO1IH1AZ3iiEHzx95ZC9+aqD7pB7lMQ0MQ8uHjfQLR4="; # db2
  };

  # Needs wps extension.
  dxf = mkGeoserverExtension {
    name = "dxf";
    version = "2.27.1"; # dxf
    hash = "sha256-DxQWW59+FslrmX601CffZabF+uZA+ujHVGmbwatQT9M="; # dxf
  };

  excel = mkGeoserverExtension {
    name = "excel";
    version = "2.27.1"; # excel
    hash = "sha256-G6KBuBVxW879GffpKJVJgK2sO65S+zfUsKomXPBUejA="; # excel
  };

  feature-pregeneralized = mkGeoserverExtension {
    name = "feature-pregeneralized";
    version = "2.27.1"; # feature-pregeneralized
    hash = "sha256-wbUZAWTSFDutmGUhkFI0Hl/WbZRb5sLet2FdZmxLeLM="; # feature-pregeneralized
  };

  # Note: The extension name ("gdal") clashes with pkgs.gdal.
  gdal = mkGeoserverExtension {
    name = "gdal";
    version = "2.27.1"; # gdal
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-xw6DoOxImOLnmPxYMkaH4bKes0vVobzvT1IiDywq828="; # gdal
  };

  # Throws "java.io.FileNotFoundException: URL [jar:file:/nix/store/.../WEB-INF/lib/gs-geofence-server-2.24.1.jar!/geofence-default-override.properties] cannot be resolved to absolute file path because it does not reside in the file system: jar:file:/nix/store/.../WEB-INF/lib/gs-geofence-server-2.24.1.jar!/geofence-default-override.properties" but seems to work out of the box.
  #geofence = mkGeoserverExtension {
  #  name = "geofence";
  #  version = "2.27.1"; # geofence
  #  hash = "sha256-ccbCBCrb4zbZQ2eCDZo/FOT2IiUhruV62h7SrITdPdw="; # geofence
  #};

  #geofence-server = mkGeoserverExtension {
  #  name = "geofence-server";
  #  version = "2.27.1"; # geofence-server
  #  hash = ""; # geofence-server
  #};

  #geofence-wps = mkGeoserverExtension {
  #  name = "geofence-wps";
  #  version = "2.27.1"; # geofence-wps
  #  hash = "sha256-k2z+xBUZw7cz/sPRjAEsKey6oqY1FzpaMGJcCm73kdg="; # geofence-wps
  #};

  geopkg-output = mkGeoserverExtension {
    name = "geopkg-output";
    version = "2.27.1"; # geopkg-output
    hash = "sha256-wECoUeBJLh00hJHT/adz7YF8AraPl1rOd9GLL1BP5dU="; # geopkg-output
  };

  grib = mkGeoserverExtension {
    name = "grib";
    version = "2.27.1"; # grib
    hash = "sha256-gu8sDIA46u0Uj9+lJJ65mn3FD6D+DjsTN8KbNUeoOP0="; # grib
    buildInputs = [ netcdf ];
  };

  gwc-s3 = mkGeoserverExtension {
    name = "gwc-s3";
    version = "2.27.1"; # gwc-s3
    hash = "sha256-UBy17pwwjDJFBIgUyQSThj3Kn1bber/pglsUr/h4d+Q="; # gwc-s3
  };

  h2 = mkGeoserverExtension {
    name = "h2";
    version = "2.27.1"; # h2
    hash = "sha256-cXtc5OBAn3ppoGns6MvivgCYW841LJt1SPi5nNDE2O8="; # h2
  };

  iau = mkGeoserverExtension {
    name = "iau";
    version = "2.27.1"; # iau
    hash = "sha256-77ULte2jCRN+gfd9/tOL26RX7EjKK6h5JaqQBR8TSI8="; # iau
  };

  importer = mkGeoserverExtension {
    name = "importer";
    version = "2.27.1"; # importer
    hash = "sha256-qrwMz7R/m/BtwNUcJV+mJu8pTNS+00EjWq/hMnF3/T0="; # importer
  };

  inspire = mkGeoserverExtension {
    name = "inspire";
    version = "2.27.1"; # inspire
    hash = "sha256-fjMkmAmq9BGsnwjUH8I/iCZveAPEYi9E9/R2WNg6rxo="; # inspire
  };

  # Needs Kakadu plugin from
  # https://github.com/geosolutions-it/imageio-ext
  #jp2k = mkGeoserverExtension {
  #  name = "jp2k";
  #  version = "2.27.1"; # jp2k
  #  hash = "sha256-guNAdKOu32t0a648nuUjkt5bu17OKLAn6QXYeyAe1ZA="; # jp2k
  #};

  libjpeg-turbo = mkGeoserverExtension {
    name = "libjpeg-turbo";
    version = "2.27.1"; # libjpeg-turbo
    hash = "sha256-ZAIQJzzDNSgCX4BUchyRktobJkyLHgWYwfPz8B9vNTQ="; # libjpeg-turbo
    buildInputs = [ libjpeg.out ];
  };

  mapml = mkGeoserverExtension {
    name = "mapml";
    version = "2.27.1"; # mapml
    hash = "sha256-znx6KjpTT109wG2wsTyvwKFcij29TVJ0cOkEIJw1D0g="; # mapml
  };

  mbstyle = mkGeoserverExtension {
    name = "mbstyle";
    version = "2.27.1"; # mbstyle
    hash = "sha256-t2g9Pm1PsfbiP1UWHcZaILZQFeOxnKUMXGS1sJfQcVg="; # mbstyle
  };

  metadata = mkGeoserverExtension {
    name = "metadata";
    version = "2.27.1"; # metadata
    hash = "sha256-DPD83rrjn8oPRXn28EFDgvxdhUtI3goPN2FpyPjyGks="; # metadata
  };

  mongodb = mkGeoserverExtension {
    name = "mongodb";
    version = "2.27.1"; # mongodb
    hash = "sha256-lVaEOf91CKBYfI8QLXhERfQ+aWNTTok2DveiZlWygjQ="; # mongodb
  };

  monitor = mkGeoserverExtension {
    name = "monitor";
    version = "2.27.1"; # monitor
    hash = "sha256-goZz5+dxB787hjcoR/Cmo92mw+rhpoooETzxg8bQ4eE="; # monitor
  };

  mysql = mkGeoserverExtension {
    name = "mysql";
    version = "2.27.1"; # mysql
    hash = "sha256-jn+zmnrJHWw6/OXCnEpoBPtUALhINjL42va1+eGXgeU="; # mysql
  };

  netcdf = mkGeoserverExtension {
    name = "netcdf";
    version = "2.27.1"; # netcdf
    hash = "sha256-W/ICO05gBf5o6ZAc8vbxv9ZWd02m6AMQKqyimpVvRX8="; # netcdf
    buildInputs = [ netcdf ];
  };

  netcdf-out = mkGeoserverExtension {
    name = "netcdf-out";
    version = "2.27.1"; # netcdf-out
    hash = "sha256-0l74QlXo3CwTja2DDx8fmD9DTJV3S6fdCi2r6oq6UwE="; # netcdf-out
    buildInputs = [ netcdf ];
  };

  ogr-wfs = mkGeoserverExtension {
    name = "ogr-wfs";
    version = "2.27.1"; # ogr-wfs
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-UXTpC4vd/2lq2mRMaTEwiIb58NtnsM+PEX2F6hsCv3s="; # ogr-wfs
  };

  # Needs ogr-wfs extension.
  ogr-wps = mkGeoserverExtension {
    name = "ogr-wps";
    version = "2.27.1"; # ogr-wps
    # buildInputs = [ pkgs.gdal ];
    hash = "sha256-GgVVGEBm7ci4Qxe+hNiIuGGOoJQRvaZE+NYKY0ZJlAQ="; # ogr-wps
  };

  oracle = mkGeoserverExtension {
    name = "oracle";
    version = "2.27.1"; # oracle
    hash = "sha256-7NH0XW+dZWIgJ8rwzNjCXLS2c4lCFg0FzNM8AD17Z3E="; # oracle
  };

  params-extractor = mkGeoserverExtension {
    name = "params-extractor";
    version = "2.27.1"; # params-extractor
    hash = "sha256-Z3pM5Mt1RE1+aDfsjcMrx4u6SvUzOUQmrmfghCCQIYk="; # params-extractor
  };

  printing = mkGeoserverExtension {
    name = "printing";
    version = "2.27.1"; # printing
    hash = "sha256-/kkUQpARHi2J/+4Tc9z7pVGLhnwbrlxOxiUlbg646KQ="; # printing
  };

  pyramid = mkGeoserverExtension {
    name = "pyramid";
    version = "2.27.1"; # pyramid
    hash = "sha256-b4ZZNXHOgywXkPwTWBANyl0r1bok4bybusI0tKZ7rY8="; # pyramid
  };

  querylayer = mkGeoserverExtension {
    name = "querylayer";
    version = "2.27.1"; # querylayer
    hash = "sha256-8leo1ZtrYbN9XISJLVZvOF34arOEnh0Y8CIeWih8XOE="; # querylayer
  };

  sldservice = mkGeoserverExtension {
    name = "sldservice";
    version = "2.27.1"; # sldservice
    hash = "sha256-nKG1/+NwmTaardqZAhB4A1QV6bPxc30jW9Ip/q2vUJ0="; # sldservice
  };

  sqlserver = mkGeoserverExtension {
    name = "sqlserver";
    version = "2.27.1"; # sqlserver
    hash = "sha256-aqQf7NwUPnNn9Byu8YmbMnsU3n3aq832rvXbvicQsrM="; # sqlserver
  };

  vectortiles = mkGeoserverExtension {
    name = "vectortiles";
    version = "2.27.1"; # vectortiles
    hash = "sha256-8nITeBDeFX6bDx+2Sn4yHfb333XUdNGPV6I883nZLV0="; # vectortiles
  };

  wcs2_0-eo = mkGeoserverExtension {
    name = "wcs2_0-eo";
    version = "2.27.1"; # wcs2_0-eo
    hash = "sha256-y3QOWFmYW+dxIAAlolcotJ0oNulRIJKvLeQqSTZKq/w="; # wcs2_0-eo
  };

  web-resource = mkGeoserverExtension {
    name = "web-resource";
    version = "2.27.1"; # web-resource
    hash = "sha256-hfP/qnb4isWg4eoxfBCDpiLS4GBG/ysrGBE6HVbglMg="; # web-resource
  };

  wmts-multi-dimensional = mkGeoserverExtension {
    name = "wmts-multi-dimensional";
    version = "2.27.1"; # wmts-multi-dimensional
    hash = "sha256-/KfE5dLvbSeMn/w7NYKQtUIY/Wb1oWeLvdMEqgrNAhg="; # wmts-multi-dimensional
  };

  wps = mkGeoserverExtension {
    name = "wps";
    version = "2.27.1"; # wps
    hash = "sha256-rsBUWUthRrBkSNIzZZZzIy56bsJYt9zy3cIzWQVHVGc="; # wps
  };

  # Needs hazelcast (https://github.com/hazelcast/hazelcast (?)) which is not
  # available in nixpgs as of 2024/01.
  #wps-cluster-hazelcast = mkGeoserverExtension {
  #  name = "wps-cluster-hazelcast";
  #  version = "2.27.1"; # wps-cluster-hazelcast
  #  hash = "sha256-W0hIz/Bx/x0ATLhcljSWa9/qzltt3FKlWyxub4Lnsx0="; # wps-cluster-hazelcast
  #};

  wps-download = mkGeoserverExtension {
    name = "wps-download";
    version = "2.27.1"; # wps-download
    hash = "sha256-gt3u/zm8ME99d7zJV1EHQQYjC1IZyG7f5pV+Zt2XeJU="; # wps-download
  };

  # Needs Postrgres configuration or similar.
  # See https://docs.geoserver.org/main/en/user/extensions/wps-jdbc/index.html
  wps-jdbc = mkGeoserverExtension {
    name = "wps-jdbc";
    version = "2.27.1"; # wps-jdbc
    hash = "sha256-5RtViHAgqAtnHQolqGMC7QYgnwQmn/sO4WdUx2gyxe8="; # wps-jdbc
  };

  ysld = mkGeoserverExtension {
    name = "ysld";
    version = "2.27.1"; # ysld
    hash = "sha256-DvQ8b6ODmU09Qixwe14wze92ktWyt54+zaEMfXjiEko="; # ysld
  };

}
