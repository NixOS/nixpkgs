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
<<<<<<< HEAD
        url = "https://sourceforge.net/projects/geoserver/files/GeoServer/${version}/extensions/geoserver-${version}-${name}-plugin.zip";
=======
        url = "mirror://sourceforge/geoserver/GeoServer/${version}/extensions/geoserver-${version}-${name}-plugin.zip";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    version = "2.28.1"; # app-schema
    hash = "sha256-PwZW9hFRiZIxgil75DXMsq0ymo7jPYX4Boj+hkXW8NI="; # app-schema
=======
    version = "2.27.2"; # app-schema
    hash = "sha256-XJbuRdqvkusT1hZEuFoogTEB8vHOsX9cQxA0Mzhg1+8="; # app-schema
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  authkey = mkGeoserverExtension {
    name = "authkey";
<<<<<<< HEAD
    version = "2.28.1"; # authkey
    hash = "sha256-Zg3Db5QG4w+yMZ75MqtHt1Kri8peDGMZ0va5ZwI+6dw="; # authkey
=======
    version = "2.27.2"; # authkey
    hash = "sha256-e43HG4iPgj9vj7lq0c9ATmWVumqHdtM9DrAwbQJqUcg="; # authkey
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  cas = mkGeoserverExtension {
    name = "cas";
<<<<<<< HEAD
    version = "2.28.1"; # cas
    hash = "sha256-YMnaRVPLn98mXm2sErKSRlzmvQbnU9MGMDXuYgwm+H0="; # cas
=======
    version = "2.27.2"; # cas
    hash = "sha256-kDYC8z5sRAycw6ZCKJ105XoYF5/ss4YTguqQ8pbnJls="; # cas
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  charts = mkGeoserverExtension {
    name = "charts";
<<<<<<< HEAD
    version = "2.28.1"; # charts
    hash = "sha256-LM75iq2xvSQjVxGnngoLCz5IkSI9/YqAqOqgSUlkrUA="; # charts
=======
    version = "2.27.2"; # charts
    hash = "sha256-zI+F21bQHcE4Lbh26bHeCTjTRJdswkUmmz+qAsP2t4k="; # charts
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  control-flow = mkGeoserverExtension {
    name = "control-flow";
<<<<<<< HEAD
    version = "2.28.1"; # control-flow
    hash = "sha256-ZO04mls+OapOK/fi5IBy0mVJ5cF0fyQ1RgFhWt0AuEw="; # control-flow
=======
    version = "2.27.2"; # control-flow
    hash = "sha256-5XW3l9MFEUeYuhOKqN4EqjwpRlMc8P8Tn46A2Z89Jks="; # control-flow
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  css = mkGeoserverExtension {
    name = "css";
<<<<<<< HEAD
    version = "2.28.1"; # css
    hash = "sha256-2PcZhxkHXEOAs46fnt37VhupVOfRNWaRynNlLGviAho="; # css
=======
    version = "2.27.2"; # css
    hash = "sha256-1fpP70Ed4iUrUyMMiMFhkykuPCzBV5+lWFicl9sUjAg="; # css
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  csw = mkGeoserverExtension {
    name = "csw";
<<<<<<< HEAD
    version = "2.28.1"; # csw
    hash = "sha256-6TmSWnny0OedvnLu+HnKpVxdfcicp1D//isFFOclcmk="; # csw
=======
    version = "2.27.2"; # csw
    hash = "sha256-4BYSY6tldkjd8KDlM/D+MNb9I8Ji0CVjyJcsBzRxC1Y="; # csw
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  csw-iso = mkGeoserverExtension {
    name = "csw-iso";
<<<<<<< HEAD
    version = "2.28.1"; # csw-iso
    hash = "sha256-BlnIS8gpWwBuiwdIqvq3UpJrdKPULvJxR7o3XJtI5tQ="; # csw-iso
=======
    version = "2.27.2"; # csw-iso
    hash = "sha256-/0soY61A1d4yKJolRtymoFOsKf42B/RacUSUqN/7uXo="; # csw-iso
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  db2 = mkGeoserverExtension {
    name = "db2";
<<<<<<< HEAD
    version = "2.28.1"; # db2
    hash = "sha256-Ga4Db6G+LxRN+casjs0nYD6TFN1YrDjgOIlu46/0RgQ="; # db2
=======
    version = "2.27.2"; # db2
    hash = "sha256-agZZHkwAx5YTOCzDlhpiTWxBTyhAoIW1BgW3QfV/kug="; # db2
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  # Needs wps extension.
  dxf = mkGeoserverExtension {
    name = "dxf";
<<<<<<< HEAD
    version = "2.28.1"; # dxf
    hash = "sha256-703y8CBd9oYsryGgAftXq5Cr1lUeyws1Alx0tSwzZo8="; # dxf
=======
    version = "2.27.2"; # dxf
    hash = "sha256-F93QOpe0nBQDD+8iDnenacNJ87h+jCqytJ3uz7weCcg="; # dxf
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  excel = mkGeoserverExtension {
    name = "excel";
<<<<<<< HEAD
    version = "2.28.1"; # excel
    hash = "sha256-9ti+J7e9QieVbCFQ2xxuqX8TvQCcLPw0tPUNVqGG9+0="; # excel
=======
    version = "2.27.2"; # excel
    hash = "sha256-CYW9JBhDOLqxNKnlxNDy03sZzmGPLn9KaK4LScGMIIg="; # excel
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  feature-pregeneralized = mkGeoserverExtension {
    name = "feature-pregeneralized";
<<<<<<< HEAD
    version = "2.28.1"; # feature-pregeneralized
    hash = "sha256-eGayG9FUJabhP60iypib1gLcRStqz5J4PMTuSB+xL60="; # feature-pregeneralized
=======
    version = "2.27.2"; # feature-pregeneralized
    hash = "sha256-0MuzhZ8Y/yy/AJ6vTvfJxXPgnf+fTJPfB8wNTboYHOw="; # feature-pregeneralized
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  # Note: The extension name ("gdal") clashes with pkgs.gdal.
  gdal = mkGeoserverExtension {
    name = "gdal";
<<<<<<< HEAD
    version = "2.28.1"; # gdal
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-sVI9o2xwbvez7Gm8gY9DAbEr5TUluVGDoC7ZweK4BUE="; # gdal
=======
    version = "2.27.2"; # gdal
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-Krdj96ddLsrA8J6B8ap3BBBe/+flVX7/GJRLN4UnKiY="; # gdal
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  # Throws "java.io.FileNotFoundException: URL [jar:file:/nix/store/.../WEB-INF/lib/gs-geofence-server-2.24.1.jar!/geofence-default-override.properties] cannot be resolved to absolute file path because it does not reside in the file system: jar:file:/nix/store/.../WEB-INF/lib/gs-geofence-server-2.24.1.jar!/geofence-default-override.properties" but seems to work out of the box.
  #geofence = mkGeoserverExtension {
  #  name = "geofence";
<<<<<<< HEAD
  #  version = "2.28.1"; # geofence
  #  hash = "sha256-POBOhg3d8HlA3qF2W41UTVhISM5vAQi74cI+y+Rj+Ic="; # geofence
  #};

  #geofence-server-h2 = mkGeoserverExtension {
  #  name = "geofence-server-h2";
  #  version = "2.28.1"; # geofence-server
  #  hash = "sha256-8lY+wrCD7PizeNvh9hDRhxdFxT7n1SVKD8TVU80iiZk="; # geofence-server-h2
  #};

  #geofence-server-postgres = mkGeoserverExtension {
  #  name = "geofence-server-postgres";
  #  version = "2.28.1"; # geofence-server
  #  hash = "sha256-DB3OK2dvPrDtlRRHaDUXqQW7AlOhN4zFm2t0N1+B3rk="; # geofence-server-postgres
=======
  #  version = "2.27.2"; # geofence
  #  hash = "sha256-Rzi8oZFy+SglTuPSYBFi/Wge4pOVY5yE50c8+jRI+4Y="; # geofence
  #};

  #geofence-server = mkGeoserverExtension {
  #  name = "geofence-server";
  #  version = "2.27.2"; # geofence-server
  #  hash = ""; # geofence-server
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  #};

  #geofence-wps = mkGeoserverExtension {
  #  name = "geofence-wps";
<<<<<<< HEAD
  #  version = "2.28.1"; # geofence-wps
  #  hash = "sha256-tP3hnN0kXKFIdgKrS7juyrCh1OoQD0Bx54/xq6nUzWA="; # geofence-wps
=======
  #  version = "2.27.2"; # geofence-wps
  #  hash = "sha256-dry787XPCVBPi4TXKyFL85QZwX0WdWfiXqz/yriMiWc="; # geofence-wps
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  #};

  geopkg-output = mkGeoserverExtension {
    name = "geopkg-output";
<<<<<<< HEAD
    version = "2.28.1"; # geopkg-output
    hash = "sha256-6ARKLmhc5lhqi841Ou5ZrBuj6bdOwQDSGPwzGcBTNJw="; # geopkg-output
=======
    version = "2.27.2"; # geopkg-output
    hash = "sha256-LlYjYTa0mjOh+q2ILJORTAUlWy3mW9lEMd1vUyyhDV8="; # geopkg-output
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  grib = mkGeoserverExtension {
    name = "grib";
<<<<<<< HEAD
    version = "2.28.1"; # grib
    hash = "sha256-AW/i+vRthQct3U45EGw/6uPDZNdS9z816nnKVIGCg/k="; # grib
=======
    version = "2.27.2"; # grib
    hash = "sha256-/OBhwToUuJfDcRnx4aJbXDb6HdGGtM8SCkjmFgfX65s="; # grib
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    buildInputs = [ netcdf ];
  };

  gwc-s3 = mkGeoserverExtension {
    name = "gwc-s3";
<<<<<<< HEAD
    version = "2.28.1"; # gwc-s3
    hash = "sha256-wVLW7qbKDRmf1okTI0PDREQ5eoJOVGMVLS+uusY2+cM="; # gwc-s3
=======
    version = "2.27.2"; # gwc-s3
    hash = "sha256-A0I2/+pRuvcXCVduTNn/e1nDZnNkt7cKtPNNO3Yo8Bk="; # gwc-s3
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  h2 = mkGeoserverExtension {
    name = "h2";
<<<<<<< HEAD
    version = "2.28.1"; # h2
    hash = "sha256-zEjNN1dCmNR/5st/yNpWP1G3P6Zqf3RSFdUKOgdwff4="; # h2
=======
    version = "2.27.2"; # h2
    hash = "sha256-kGXqb5xH4Jn6nhN8nfhldUcHtQodBUp9y3bviPim1Ak="; # h2
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  iau = mkGeoserverExtension {
    name = "iau";
<<<<<<< HEAD
    version = "2.28.1"; # iau
    hash = "sha256-zn4FlC/vVvq1K6mSplOKarHHUWLNev5IW76wSiTvBuE="; # iau
=======
    version = "2.27.2"; # iau
    hash = "sha256-KVkpQ92cvmc3nIsBygUU58vsIY8BZXEEXQrUeH/eEyM="; # iau
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  importer = mkGeoserverExtension {
    name = "importer";
<<<<<<< HEAD
    version = "2.28.1"; # importer
    hash = "sha256-7v5MvpvVbVKOBxUlEwem8MzPUTtBc8z+1JAEqeHUmYI="; # importer
=======
    version = "2.27.2"; # importer
    hash = "sha256-Sumh9148zqwLCbpiknwLyVpxqufkoizMgszy//qC5dA="; # importer
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  inspire = mkGeoserverExtension {
    name = "inspire";
<<<<<<< HEAD
    version = "2.28.1"; # inspire
    hash = "sha256-kgqwO3elSnT/4M9G+OgULaW+i/nDNGhvHblmWZRjTTA="; # inspire
=======
    version = "2.27.2"; # inspire
    hash = "sha256-IDX93Cu7BgrkmI5QcdYu++XzVwHOeCM17eXgqhDPSRQ="; # inspire
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  # Needs Kakadu plugin from
  # https://github.com/geosolutions-it/imageio-ext
  #jp2k = mkGeoserverExtension {
  #  name = "jp2k";
<<<<<<< HEAD
  #  version = "2.28.1"; # jp2k
  #  hash = "sha256-sLUgsMXymnTuceCRLzqIAPmk4/Q3BO+A+7BLQoc3iP0="; # jp2k
  #};

  # Throws "java.lang.UnsatisfiedLinkError: 'void org.libjpegturbo.turbojpeg.TJDecompressor.init()'"
  # as of 2.28.1.
  # NOTE: When re-enabling this, RE-ENABLE THE CORRESPONDING TEST, TOO! (See tests/geoserver.nix)
  #libjpeg-turbo = mkGeoserverExtension {
  #  name = "libjpeg-turbo";
  #  version = "2.28.1"; # libjpeg-turbo
  #  hash = "sha256-fn1ItYvLMfvRLpCE8rEpTpBmkk8zkN3QtBO/RN4RXfo="; # libjpeg-turbo
  #  buildInputs = [ libjpeg.out ];
  #};

  mapml = mkGeoserverExtension {
    name = "mapml";
    version = "2.28.1"; # mapml
    hash = "sha256-AonH/wBRh0oVs8psJ+XRutkSwybN3fs505SI/0qzG3o="; # mapml
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  mbstyle = mkGeoserverExtension {
    name = "mbstyle";
<<<<<<< HEAD
    version = "2.28.1"; # mbstyle
    hash = "sha256-SvgvBkp6dS6v1JjQxpa7m7tqc2c63hruWCcFcouHXaQ="; # mbstyle
=======
    version = "2.27.2"; # mbstyle
    hash = "sha256-zKdX77zy72lkMB928XIjU0pYZ7zFVEI7OfbJ2ozFIHk="; # mbstyle
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  metadata = mkGeoserverExtension {
    name = "metadata";
<<<<<<< HEAD
    version = "2.28.1"; # metadata
    hash = "sha256-M3HcgrPGZBBotNm6dsw4UjrH1onIQHDMdxuwNVuqO84="; # metadata
=======
    version = "2.27.2"; # metadata
    hash = "sha256-VLBuqh9qfcv2BRHhjF1tAc6ACCOUPQcY4Yc0Vko/2l0="; # metadata
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  mongodb = mkGeoserverExtension {
    name = "mongodb";
<<<<<<< HEAD
    version = "2.28.1"; # mongodb
    hash = "sha256-Urp8d0i6Xlk2muNKKioJTnrEvzC05tqiipLT162L7uk="; # mongodb
=======
    version = "2.27.2"; # mongodb
    hash = "sha256-xXgiOEMQhPbw6GorrkEiyV7isgmSuimzT/LK41c0bzA="; # mongodb
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  monitor = mkGeoserverExtension {
    name = "monitor";
<<<<<<< HEAD
    version = "2.28.1"; # monitor
    hash = "sha256-Qo9aFOjbg9s1RZVqa/z1ka+QmFrPZJgrH8qMcstCywQ="; # monitor
=======
    version = "2.27.2"; # monitor
    hash = "sha256-1x+Rz8wXl3cAsX5rHgMEe1+h17QS7PDBJGDFmKf+SMY="; # monitor
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  mysql = mkGeoserverExtension {
    name = "mysql";
<<<<<<< HEAD
    version = "2.28.1"; # mysql
    hash = "sha256-5/xP8vPNhOYN9YXL4sZk16652ZBB7Ivm7Cq05fYi7wI="; # mysql
=======
    version = "2.27.2"; # mysql
    hash = "sha256-mmquP4u3YqqbGVK2jkbNtGiqVMENCThpRTWOz6f74Pk="; # mysql
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  netcdf = mkGeoserverExtension {
    name = "netcdf";
<<<<<<< HEAD
    version = "2.28.1"; # netcdf
    hash = "sha256-qKgSyFrKI7JVMNt/qjgJ5puLaTsU406P5VyUpncMHOg="; # netcdf
=======
    version = "2.27.2"; # netcdf
    hash = "sha256-GhPde3Fw04lutbgPmDyxO/C7wkZO1ttASqqj2g6JuCM="; # netcdf
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    buildInputs = [ netcdf ];
  };

  netcdf-out = mkGeoserverExtension {
    name = "netcdf-out";
<<<<<<< HEAD
    version = "2.28.1"; # netcdf-out
    hash = "sha256-Xk3cTve45U9LDv8lWugtGpfid4yr5yDWh7H7daVlAc8="; # netcdf-out
=======
    version = "2.27.2"; # netcdf-out
    hash = "sha256-r4CyrlRm04tE3+vJfF+KlHAczrOy+dsTHXBG++GG0ys="; # netcdf-out
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    buildInputs = [ netcdf ];
  };

  ogr-wfs = mkGeoserverExtension {
    name = "ogr-wfs";
<<<<<<< HEAD
    version = "2.28.1"; # ogr-wfs
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-ykFfqoLXeGigAdCLnDCKiCGD++n7jiOivua8Oh2DwU8="; # ogr-wfs
=======
    version = "2.27.2"; # ogr-wfs
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-EI0FNYFwcmsLYiYauvCAvweAIn6bI7WaCVPcCtkGrys="; # ogr-wfs
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  # Needs ogr-wfs extension.
  ogr-wps = mkGeoserverExtension {
    name = "ogr-wps";
<<<<<<< HEAD
    version = "2.28.1"; # ogr-wps
    # buildInputs = [ pkgs.gdal ];
    hash = "sha256-WxOZ5WDNxV1HAT9cfCPm9DwoU/96OobuODOjd5dGN94="; # ogr-wps
=======
    version = "2.27.2"; # ogr-wps
    # buildInputs = [ pkgs.gdal ];
    hash = "sha256-CtsaQg9IZxlRW4oQwmdBA+VLWtsNP3+jS1Mj2RxAJw4="; # ogr-wps
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  oracle = mkGeoserverExtension {
    name = "oracle";
<<<<<<< HEAD
    version = "2.28.1"; # oracle
    hash = "sha256-lj53CC6f9vXatH9vxHaFZvEGDpplTZSYy56fz4d4Qs0="; # oracle
=======
    version = "2.27.2"; # oracle
    hash = "sha256-8cRDvWWFJHZZGmbZEruvp1whfhXZ/c7TYha4Fa5DuzM="; # oracle
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  params-extractor = mkGeoserverExtension {
    name = "params-extractor";
<<<<<<< HEAD
    version = "2.28.1"; # params-extractor
    hash = "sha256-1Znwqb+PHFlsuQIs8pMqo08s4uSc7wLZRYE+hVZzoQY="; # params-extractor
=======
    version = "2.27.2"; # params-extractor
    hash = "sha256-Y7tt0F//dANcKds/mU6702S5PMJNVLcxxc+hYFNOt5M="; # params-extractor
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  printing = mkGeoserverExtension {
    name = "printing";
<<<<<<< HEAD
    version = "2.28.1"; # printing
    hash = "sha256-OeMHkx4d7/FwNigQ8Mnz9UlqFJbMZFGmxZT8kJ3iPp8="; # printing
=======
    version = "2.27.2"; # printing
    hash = "sha256-I5vVlpX2kXof3wuyRs2QvhWdx0Okm7StYvY8I/AL8Ug="; # printing
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  pyramid = mkGeoserverExtension {
    name = "pyramid";
<<<<<<< HEAD
    version = "2.28.1"; # pyramid
    hash = "sha256-fLe2SeRSNvj6qqh6CMDu2w0gubf+xi3Ez7jO2fEbpjc="; # pyramid
=======
    version = "2.27.2"; # pyramid
    hash = "sha256-/iIwS5iw95qotmmLWGU11br36dVc+o5LmwTDXBL7zaY="; # pyramid
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  querylayer = mkGeoserverExtension {
    name = "querylayer";
<<<<<<< HEAD
    version = "2.28.1"; # querylayer
    hash = "sha256-QM5DAoTFsn6JTLubQy4p0qsA91DcfU7C74cb80jzzWM="; # querylayer
=======
    version = "2.27.2"; # querylayer
    hash = "sha256-G66AkPkytzXvEi9hbudvBphFKrvMrhUbPSVvexXRJh4="; # querylayer
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  sldservice = mkGeoserverExtension {
    name = "sldservice";
<<<<<<< HEAD
    version = "2.28.1"; # sldservice
    hash = "sha256-u5uzwyrwBzz5qcEtRS+ZIbmis9kVuGPt6+qo19K1HCM="; # sldservice
=======
    version = "2.27.2"; # sldservice
    hash = "sha256-djERawjM06NtZK6RnNh/qIS/x5ZjSWeUMHlUSF4/5aA="; # sldservice
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  sqlserver = mkGeoserverExtension {
    name = "sqlserver";
<<<<<<< HEAD
    version = "2.28.1"; # sqlserver
    hash = "sha256-19KyMBZEYBeUKiogxux8jrc8VgNDdCnvhrEV8Q84SG0="; # sqlserver
=======
    version = "2.27.2"; # sqlserver
    hash = "sha256-Kad2wJmN/67xlLDViFfYWxvsSjmW+j3/iQEAvwEMZW4="; # sqlserver
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  vectortiles = mkGeoserverExtension {
    name = "vectortiles";
<<<<<<< HEAD
    version = "2.28.1"; # vectortiles
    hash = "sha256-tT4phUdL8yMKzobxWNivMpHJYu6KQmPiNECK9TtJgjg="; # vectortiles
=======
    version = "2.27.2"; # vectortiles
    hash = "sha256-S5ujjj8JLXbybbjpA8qLF4sapVIECDZ8l+iqqUoVHuc="; # vectortiles
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  wcs2_0-eo = mkGeoserverExtension {
    name = "wcs2_0-eo";
<<<<<<< HEAD
    version = "2.28.1"; # wcs2_0-eo
    hash = "sha256-HawDOyymB01x7PaFg5QKQhTSFdybeY5oAAusaG95To8="; # wcs2_0-eo
=======
    version = "2.27.2"; # wcs2_0-eo
    hash = "sha256-S2d3Yel0B0DJubuMUywPB2gDiWIpdkniDksZcq8j9BI="; # wcs2_0-eo
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  web-resource = mkGeoserverExtension {
    name = "web-resource";
<<<<<<< HEAD
    version = "2.28.1"; # web-resource
    hash = "sha256-FkuxR3WN95jyorpcv4ShT9J6jmUi0Z9NNwLEW3OKzx0="; # web-resource
=======
    version = "2.27.2"; # web-resource
    hash = "sha256-HJ+GPrprrCPlzh9q+PZr0QEJE/YVXaqgxhUlYHPkgho="; # web-resource
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  wmts-multi-dimensional = mkGeoserverExtension {
    name = "wmts-multi-dimensional";
<<<<<<< HEAD
    version = "2.28.1"; # wmts-multi-dimensional
    hash = "sha256-tJP9pPKKYFLGbLWZEV5gWSaQdTbml3OKiIPM1sqhekY="; # wmts-multi-dimensional
=======
    version = "2.27.2"; # wmts-multi-dimensional
    hash = "sha256-de+0UEsRJyl9plnmOaWSI8xNc6RG+U7uJVEyvgwng4Q="; # wmts-multi-dimensional
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  wps = mkGeoserverExtension {
    name = "wps";
<<<<<<< HEAD
    version = "2.28.1"; # wps
    hash = "sha256-aYAN89XFpwzsW5aRBKSnixks3bxCAfOOznFDpoIvbIk="; # wps
=======
    version = "2.27.2"; # wps
    hash = "sha256-Fn0XWncwqUmMub9eBxb5GN2cc3eMdyB55NB9AUvVQpQ="; # wps
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  # Needs hazelcast (https://github.com/hazelcast/hazelcast (?)) which is not
  # available in nixpgs as of 2024/01.
  #wps-cluster-hazelcast = mkGeoserverExtension {
  #  name = "wps-cluster-hazelcast";
<<<<<<< HEAD
  #  version = "2.28.1"; # wps-cluster-hazelcast
  #  hash = "sha256-hO1/7OG9J5Ot5xKhMUbTAqm7B6TlecqNGxxbIuFCpCc="; # wps-cluster-hazelcast
=======
  #  version = "2.27.2"; # wps-cluster-hazelcast
  #  hash = "sha256-xV6JddIC5Uq8H3RaE9tqCMK+5OA5WrXfh6O82BVw+P0="; # wps-cluster-hazelcast
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  #};

  wps-download = mkGeoserverExtension {
    name = "wps-download";
<<<<<<< HEAD
    version = "2.28.1"; # wps-download
    hash = "sha256-qB1vtczNULOsEjZaof9cA5YKPDE0Dwcz6mlUtzCanPQ="; # wps-download
=======
    version = "2.27.2"; # wps-download
    hash = "sha256-loP1oYqie2U00RWOwlLzprECfnBTG2MeJNhPZJx8Q1o="; # wps-download
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  # Needs Postrgres configuration or similar.
  # See https://docs.geoserver.org/main/en/user/extensions/wps-jdbc/index.html
  wps-jdbc = mkGeoserverExtension {
    name = "wps-jdbc";
<<<<<<< HEAD
    version = "2.28.1"; # wps-jdbc
    hash = "sha256-9S6/TXK9YFzPD8u/S7SQuBcIGjUTalY69kzG4xbIU3g="; # wps-jdbc
=======
    version = "2.27.2"; # wps-jdbc
    hash = "sha256-LpxGscFx7DCeM90VGs4lAMoKNXJVDnSCptdC9VeeU/o="; # wps-jdbc
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  ysld = mkGeoserverExtension {
    name = "ysld";
<<<<<<< HEAD
    version = "2.28.1"; # ysld
    hash = "sha256-qLWnujvB32U0EW7xW12GaAx6mPHkrU5Pa3S+T8+19r8="; # ysld
=======
    version = "2.27.2"; # ysld
    hash = "sha256-1yOaJcPyLOm/lYdOazHU5DjfahSjuN00yYvxgsE5RKM="; # ysld
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

}
