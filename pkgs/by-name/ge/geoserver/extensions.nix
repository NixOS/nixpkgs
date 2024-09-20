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
    version = "2.25.3"; # app-schema
    hash = "sha256-IvcJAu62wXAh5OQkG3cTUB/X7dc/2q6Le7GSwfJL/sA="; # app-schema
  };

  authkey = mkGeoserverExtension {
    name = "authkey";
    version = "2.25.3"; # authkey
    hash = "sha256-4tEu9JOomMN/ntDHLqEwrn9lPrJ4LjTM/VuMsjARbF0="; # authkey
  };

  cas = mkGeoserverExtension {
    name = "cas";
    version = "2.25.3"; # cas
    hash = "sha256-Am8tgF5APKuTa7XI7aI9Oq9jAiDPfJhGCXErtyPpDS8="; # cas
  };

  charts = mkGeoserverExtension {
    name = "charts";
    version = "2.25.3"; # charts
    hash = "sha256-0Vu9ldBYWe4vFQ6ftEO/WsmNz3Sf3W8iPS7t9W/+5fY="; # charts
  };

  control-flow = mkGeoserverExtension {
    name = "control-flow";
    version = "2.25.3"; # control-flow
    hash = "sha256-zH+Hz7SySKRdrrmMBukXkaCziszIwOqzSmGYXWZGxs4="; # control-flow
  };

  css = mkGeoserverExtension {
    name = "css";
    version = "2.25.3"; # css
    hash = "sha256-c3VDxTGZebGCPfYhwUyENoGiDmVa1zttJEi/879RPsc="; # css
  };

  csw = mkGeoserverExtension {
    name = "csw";
    version = "2.25.3"; # csw
    hash = "sha256-8G7GY5n0bV/xvwUkTijHLnsXBD4MczIastdeGmFcfSc="; # csw
  };

  csw-iso = mkGeoserverExtension {
    name = "csw-iso";
    version = "2.25.3"; # csw-iso
    hash = "sha256-cSY981K9QiY3YJJR1zBCQArJESZO+80oIa/uj+qTsTM="; # csw-iso
  };

  db2 = mkGeoserverExtension {
    name = "db2";
    version = "2.25.3"; # db2
    hash = "sha256-0eRiLoPIWv5Bddi9RxRkxAVMSolZCpv1kKEK7FkQrXs="; # db2
  };

  # Needs wps extension.
  dxf = mkGeoserverExtension {
    name = "dxf";
    version = "2.25.3"; # dxf
    hash = "sha256-0i2F9343IhN6LZMdTj/dSP5k5QXd7Si/8ZWbxmkcdD4="; # dxf
  };

  excel = mkGeoserverExtension {
    name = "excel";
    version = "2.25.3"; # excel
    hash = "sha256-N7OCXq1HRwV1poPImct7T9ZWdbWWYprSBMarGXx33OI="; # excel
  };

  feature-pregeneralized = mkGeoserverExtension {
    name = "feature-pregeneralized";
    version = "2.25.3"; # feature-pregeneralized
    hash = "sha256-R1jv7GPT3f7D18gQoWcLXqhtULtUvA3wEeXC2Q0+eQg="; # feature-pregeneralized
  };

  # Note: The extension name ("gdal") clashes with pkgs.gdal.
  gdal = mkGeoserverExtension {
    name = "gdal";
    version = "2.25.3"; # gdal
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-n6B/FHpul29MTYuBsg0XNfTTANBXw/cSEolzIabhHA8="; # gdal
  };

  # Throws "java.io.FileNotFoundException: URL [jar:file:/nix/store/.../WEB-INF/lib/gs-geofence-server-2.24.1.jar!/geofence-default-override.properties] cannot be resolved to absolute file path because it does not reside in the file system: jar:file:/nix/store/.../WEB-INF/lib/gs-geofence-server-2.24.1.jar!/geofence-default-override.properties" but seems to work out of the box.
  #geofence = mkGeoserverExtension {
  #  name = "geofence";
  #  version = "2.25.3"; # geofence
  #  hash = "sha256-298rEz0JmFhXxfv0tpdsDOrFLyS7GcuFwp/tX/m+SyI="; # geofence
  #};

  #geofence-server = mkGeoserverExtension {
  #  name = "geofence-server";
  #  version = "2.25.3"; # geofence-server
  #  hash = "sha256-PHP6OmulBbUJ1Q7qliYXX6fAA2C8q4h4i7qCXJpVUCQ="; # geofence-server
  #};

  #geofence-wps = mkGeoserverExtension {
  #  name = "geofence-wps";
  #  version = "2.25.3"; # geofence-wps
  #  hash = "sha256-vH7gQsjfAEcpcM+JVRfbw5sH4eJz+051FBrmoS7MyYo="; # geofence-wps
  #};

  geopkg-output = mkGeoserverExtension {
    name = "geopkg-output";
    version = "2.25.3"; # geopkg-output
    hash = "sha256-frcNjS+phsyuRo4PlmcSUu2Ylp3kHA8OYm+WCBAU/UI="; # geopkg-output
  };

  grib = mkGeoserverExtension {
    name = "grib";
    version = "2.25.3"; # grib
    hash = "sha256-uQ7xe3sokrE89QTfTLynHSHE0W6LmiICO3XKkWKEJBU="; # grib
    buildInputs = [ netcdf ];
  };

  gwc-s3 = mkGeoserverExtension {
    name = "gwc-s3";
    version = "2.25.3"; # gwc-s3
    hash = "sha256-1cc3JywXaCCQUojnTVYmkq9Gz5Y1atBJmd0GDhyGAIE="; # gwc-s3
  };

  h2 = mkGeoserverExtension {
    name = "h2";
    version = "2.25.3"; # h2
    hash = "sha256-Cp/3qrjNSKztAaMrxPoZo2YfGBEezLQp6/ZGOehkixM="; # h2
  };

  iau = mkGeoserverExtension {
    name = "iau";
    version = "2.25.3"; # iau
    hash = "sha256-MV/XYF61rQjuOJSU6n0ADauFYJGF0cZk4lMSoHs9drg="; # iau
  };

  importer = mkGeoserverExtension {
    name = "importer";
    version = "2.25.3"; # importer
    hash = "sha256-T6PGv3zfiwA8DE2XZ2CusaQ0vRGZ75mO4nxONsCQU+g="; # importer
  };

  inspire = mkGeoserverExtension {
    name = "inspire";
    version = "2.25.3"; # inspire
    hash = "sha256-A4BBd0Q8NVjPLI6e8HTCg5zd4QOLQ6Ho3/2hnRXCeTM="; # inspire
  };

  # Needs Kakadu plugin from
  # https://github.com/geosolutions-it/imageio-ext
  #jp2k = mkGeoserverExtension {
  #  name = "jp2k";
  #  version = "2.25.3"; # jp2k
  #  hash = "sha256-0df5vPLYqxPAxqINwdWZ5RRJQVm/79sUcj8fB4RwMKY="; # jp2k
  #};

  libjpeg-turbo = mkGeoserverExtension {
    name = "libjpeg-turbo";
    version = "2.25.3"; # libjpeg-turbo
    hash = "sha256-vQjeYuB6JY+bMlxRXZ7HqgS2hEtmEJJvowfwhWmYkY4="; # libjpeg-turbo
    buildInputs = [ libjpeg.out ];
  };

  mapml = mkGeoserverExtension {
    name = "mapml";
    version = "2.25.3"; # mapml
    hash = "sha256-3BMCWeAFn52Uiob53eer5OqBLOgQaMTmHPFTLs51mEg="; # mapml
  };

  mbstyle = mkGeoserverExtension {
    name = "mbstyle";
    version = "2.25.3"; # mbstyle
    hash = "sha256-SJAI4ssMZZL75gx1h7gwf+4YwXP/CNEm9BTtA/JNRW4="; # mbstyle
  };

  metadata = mkGeoserverExtension {
    name = "metadata";
    version = "2.25.3"; # metadata
    hash = "sha256-Gst1cctv/oKTS+jD0y8fHFrEBJyn77fEafV+QzspQVc="; # metadata
  };

  mongodb = mkGeoserverExtension {
    name = "mongodb";
    version = "2.25.3"; # mongodb
    hash = "sha256-LVejtipIRZy3g5GKs8RkOqKHNRskf8YSD11fiFvBF3w="; # mongodb
  };

  monitor = mkGeoserverExtension {
    name = "monitor";
    version = "2.25.3"; # monitor
    hash = "sha256-+FlKgoESE0j6JXM0yozYMyz6U2TshYNd6WHsKg9frAs="; # monitor
  };

  mysql = mkGeoserverExtension {
    name = "mysql";
    version = "2.25.3"; # mysql
    hash = "sha256-gfU67lID2YSNbi1aB8m1b+zGqtVnChi56HrtcBE6Aqw="; # mysql
  };

  netcdf = mkGeoserverExtension {
    name = "netcdf";
    version = "2.25.3"; # netcdf
    hash = "sha256-aMykYIBMwH46apDudKnApNba454Yep5HZeYPqEXoqcI="; # netcdf
    buildInputs = [ netcdf ];
  };

  netcdf-out = mkGeoserverExtension {
    name = "netcdf-out";
    version = "2.25.3"; # netcdf-out
    hash = "sha256-3gGzgC7IbwpettwSf4+b8HeJRuvkUfDu0xre9wyVap4="; # netcdf-out
    buildInputs = [ netcdf ];
  };

  ogr-wfs = mkGeoserverExtension {
    name = "ogr-wfs";
    version = "2.25.3"; # ogr-wfs
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-4rcUvN1py62JMQy51rxvNfV2AQIptXuRen7tvbrno6s="; # ogr-wfs
  };

  # Needs ogr-wfs extension.
  ogr-wps = mkGeoserverExtension {
    name = "ogr-wps";
    version = "2.25.3"; # ogr-wps
    # buildInputs = [ pkgs.gdal ];
    hash = "sha256-RA1dxzjhOt7lQCu6SVSM8HiXYwtFbUfj0hdk831QE5g="; # ogr-wps
  };

  oracle = mkGeoserverExtension {
    name = "oracle";
    version = "2.25.3"; # oracle
    hash = "sha256-fKJwLh4T445da1AWPzFpp++LGWiiKhN339VWt1N0s5Q="; # oracle
  };

  params-extractor = mkGeoserverExtension {
    name = "params-extractor";
    version = "2.25.3"; # params-extractor
    hash = "sha256-zO9OwH7NCUILnxRqz1z/QJdfgsx9gfpf2R7rIsgTIr8="; # params-extractor
  };

  printing = mkGeoserverExtension {
    name = "printing";
    version = "2.25.3"; # printing
    hash = "sha256-QAy53/p+/mjCTXreKsVSRcpYgfAs7W9f+ZwE4Z6Gnx8="; # printing
  };

  pyramid = mkGeoserverExtension {
    name = "pyramid";
    version = "2.25.3"; # pyramid
    hash = "sha256-kFTNQrxibatVZzPSC6Rv/SzU3FUJYQJ3dHZ5AfR3kD8="; # pyramid
  };

  querylayer = mkGeoserverExtension {
    name = "querylayer";
    version = "2.25.3"; # querylayer
    hash = "sha256-TgQiroYcnVCe5QVIcEa8gsgYELqM2jS7RveGyetWokU="; # querylayer
  };

  sldservice = mkGeoserverExtension {
    name = "sldservice";
    version = "2.25.3"; # sldservice
    hash = "sha256-5E410iNaZVEBKzRGSBcW3JNISap2NrcFtXAuP1+cVt0="; # sldservice
  };

  sqlserver = mkGeoserverExtension {
    name = "sqlserver";
    version = "2.25.3"; # sqlserver
    hash = "sha256-TNeyegWOz/a7uFsn1hBhOgpV0vnFncwQ+U9VqyY62+g="; # sqlserver
  };

  vectortiles = mkGeoserverExtension {
    name = "vectortiles";
    version = "2.25.3"; # vectortiles
    hash = "sha256-RQGeGhfixKrwRuzgmkZ/JDWaPZyDy8fAfGe0iXZfKdY="; # vectortiles
  };

  wcs2_0-eo = mkGeoserverExtension {
    name = "wcs2_0-eo";
    version = "2.25.3"; # wcs2_0-eo
    hash = "sha256-+li0zBzyHaq0an7qHAdSXKDpvpOZProHnCoHXjyVY7Y="; # wcs2_0-eo
  };

  web-resource = mkGeoserverExtension {
    name = "web-resource";
    version = "2.25.3"; # web-resource
    hash = "sha256-m9+t3Q2yD+xqvuBvkc5jYWwtGqJit00xiHyDSLX8euE="; # web-resource
  };

  wmts-multi-dimensional = mkGeoserverExtension {
    name = "wmts-multi-dimensional";
    version = "2.25.3"; # wmts-multi-dimensional
    hash = "sha256-b/16463iotuADA/bIwTutYCiRZYusMf/yB1xEMPZe9U="; # wmts-multi-dimensional
  };

  wps = mkGeoserverExtension {
    name = "wps";
    version = "2.25.3"; # wps
    hash = "sha256-4WqZqfc80Qy3AACOb3MhDjocM02vKUEk9x8YfX5onyg="; # wps
  };

  # Needs hazelcast (https://github.com/hazelcast/hazelcast (?)) which is not
  # available in nixpgs as of 2024/01.
  #wps-cluster-hazelcast = mkGeoserverExtension {
  #  name = "wps-cluster-hazelcast";
  #  version = "2.25.3"; # wps-cluster-hazelcast
  #  hash = "sha256-EDSSNVCZdcmv8ZfB3Gj80xm/ghlWNZwpTYhEwIoegM0="; # wps-cluster-hazelcast
  #};

  wps-download = mkGeoserverExtension {
    name = "wps-download";
    version = "2.25.3"; # wps-download
    hash = "sha256-70vw5PHh1hLLAocFKlzPKDZWMjQmwUbv/L4yCJGrDQ4="; # wps-download
  };

  # Needs Postrgres configuration or similar.
  # See https://docs.geoserver.org/main/en/user/extensions/wps-jdbc/index.html
  wps-jdbc = mkGeoserverExtension {
    name = "wps-jdbc";
    version = "2.25.3"; # wps-jdbc
    hash = "sha256-5d+txy1gw36G7hXfOf5qH+bSPIRw3XeLeMCTw6yHp/M="; # wps-jdbc
  };

  ysld = mkGeoserverExtension {
    name = "ysld";
    version = "2.25.3"; # ysld
    hash = "sha256-lbjfJPv9v4HUV31Hp5ZAEOe7IceRCxN7xtUxvOi2CYU="; # ysld
  };

}
