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
    version = "2.26.2"; # app-schema
    hash = "sha256-pFjKgEuAFiEN6FJkooKqMHzkbZnQWchzzLFPsA9TDH4="; # app-schema
  };

  authkey = mkGeoserverExtension {
    name = "authkey";
    version = "2.26.2"; # authkey
    hash = "sha256-u1/dbTHZPIImVq46YGWpdsO60wg6jWmc4ttAzasKpcU="; # authkey
  };

  cas = mkGeoserverExtension {
    name = "cas";
    version = "2.26.2"; # cas
    hash = "sha256-KagmWS+VNsC1wtasa9UwNZsaUzmbZKG/SPBq91pW4R8="; # cas
  };

  charts = mkGeoserverExtension {
    name = "charts";
    version = "2.26.2"; # charts
    hash = "sha256-TDv+7JFe5N8HtxjNOFYcfdJ9kdCLBKigdvqzb9p3dow="; # charts
  };

  control-flow = mkGeoserverExtension {
    name = "control-flow";
    version = "2.26.2"; # control-flow
    hash = "sha256-QQowtOOUKJCm1C7VkDHWbIscCal3PsxFMTfi5JUZqi8="; # control-flow
  };

  css = mkGeoserverExtension {
    name = "css";
    version = "2.26.2"; # css
    hash = "sha256-MgAwSWpSVrGJYRxGt1gCiLXj8uXQ8hvCkfI+yGtZU34="; # css
  };

  csw = mkGeoserverExtension {
    name = "csw";
    version = "2.26.2"; # csw
    hash = "sha256-i3ObMkSOnCGihZm8CcMj90jG3B8pYRTX9Yd4uuholKY="; # csw
  };

  csw-iso = mkGeoserverExtension {
    name = "csw-iso";
    version = "2.26.2"; # csw-iso
    hash = "sha256-zEVkldjEsI+sBbMDvvL2b6DciwwUacsufXgvIDfLYX4="; # csw-iso
  };

  db2 = mkGeoserverExtension {
    name = "db2";
    version = "2.26.2"; # db2
    hash = "sha256-g9J/KZ3ET2HSs1fhVFW8cRe409vfZddBaXoXOgVZrcE="; # db2
  };

  # Needs wps extension.
  dxf = mkGeoserverExtension {
    name = "dxf";
    version = "2.26.2"; # dxf
    hash = "sha256-Ninuw1npfy3lND0O8Tu87hv/gXPQFC3vU8H1oE8aLdc="; # dxf
  };

  excel = mkGeoserverExtension {
    name = "excel";
    version = "2.26.2"; # excel
    hash = "sha256-Lqkbr6KTtiKUmW5A3Uqem0C81oNnLd6eVzm/MwvnYjg="; # excel
  };

  feature-pregeneralized = mkGeoserverExtension {
    name = "feature-pregeneralized";
    version = "2.26.2"; # feature-pregeneralized
    hash = "sha256-T6NiDBOIpqQKEAm58558seSpHSA84w9K1C9l2Xy/sWQ="; # feature-pregeneralized
  };

  # Note: The extension name ("gdal") clashes with pkgs.gdal.
  gdal = mkGeoserverExtension {
    name = "gdal";
    version = "2.26.2"; # gdal
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-OgkoB2VY4x+6kfDDbOMKUzyd6/Q1m9YMC6sZU17qRsE="; # gdal
  };

  # Throws "java.io.FileNotFoundException: URL [jar:file:/nix/store/.../WEB-INF/lib/gs-geofence-server-2.24.1.jar!/geofence-default-override.properties] cannot be resolved to absolute file path because it does not reside in the file system: jar:file:/nix/store/.../WEB-INF/lib/gs-geofence-server-2.24.1.jar!/geofence-default-override.properties" but seems to work out of the box.
  #geofence = mkGeoserverExtension {
  #  name = "geofence";
  #  version = "2.26.2"; # geofence
  #  hash = "sha256-gXJYk64qO78hQhEmmJU98mrSYIKK/DlRPptdS6rFDD0="; # geofence
  #};

  #geofence-server = mkGeoserverExtension {
  #  name = "geofence-server";
  #  version = "2.26.2"; # geofence-server
  #  hash = "sha256-tyxIjQNmATtLy1X9dmaLugsbMyg7+2+NMx8a5jvVvDU="; # geofence-server
  #};

  #geofence-wps = mkGeoserverExtension {
  #  name = "geofence-wps";
  #  version = "2.26.2"; # geofence-wps
  #  hash = "sha256-ZU5E5SsYBpOvguYhHXLrm5IJzYtSggcF+iqB76LB05g="; # geofence-wps
  #};

  geopkg-output = mkGeoserverExtension {
    name = "geopkg-output";
    version = "2.26.2"; # geopkg-output
    hash = "sha256-XzzT6g5G26/NZzdCl4wqtQUbNfMGrc5/lI/HRN+x8BU="; # geopkg-output
  };

  grib = mkGeoserverExtension {
    name = "grib";
    version = "2.26.2"; # grib
    hash = "sha256-9onvPoSFOLODqedOLW3Bf0IJLE3UtuMSF8l4dGysMDs="; # grib
    buildInputs = [ netcdf ];
  };

  gwc-s3 = mkGeoserverExtension {
    name = "gwc-s3";
    version = "2.26.2"; # gwc-s3
    hash = "sha256-3z7DfkY/NP9ESfZWI+/ubHwHmBJM0SYyJGNVz7oAuVc="; # gwc-s3
  };

  h2 = mkGeoserverExtension {
    name = "h2";
    version = "2.26.2"; # h2
    hash = "sha256-7wsbxACFtmtL1ApQy1DT2yYzOF51nfi7CWYlUGfYoKY="; # h2
  };

  iau = mkGeoserverExtension {
    name = "iau";
    version = "2.26.2"; # iau
    hash = "sha256-j8Z5q0w6iqC++KScWoRTMOf4o7ADPN7IfPccc8A4A1M="; # iau
  };

  importer = mkGeoserverExtension {
    name = "importer";
    version = "2.26.2"; # importer
    hash = "sha256-4BObAg/3BuP8UH4yodClBJsSlTE4S2tyPtqDHqOGRYg="; # importer
  };

  inspire = mkGeoserverExtension {
    name = "inspire";
    version = "2.26.2"; # inspire
    hash = "sha256-NZ5oMXpakPfdJZg8J9Y3D/8j09H0P9CQgnpeObrGkNE="; # inspire
  };

  # Needs Kakadu plugin from
  # https://github.com/geosolutions-it/imageio-ext
  #jp2k = mkGeoserverExtension {
  #  name = "jp2k";
  #  version = "2.26.2"; # jp2k
  #  hash = "sha256-W+nx7PeEksyjA2iuN75qvWqDSdSnF0eNHAPqwce3amA="; # jp2k
  #};

  libjpeg-turbo = mkGeoserverExtension {
    name = "libjpeg-turbo";
    version = "2.26.2"; # libjpeg-turbo
    hash = "sha256-EYZQOQ1rAqTbRHh7cewkvJT4l1cmyFxNUwEFW2/8ezQ="; # libjpeg-turbo
    buildInputs = [ libjpeg.out ];
  };

  mapml = mkGeoserverExtension {
    name = "mapml";
    version = "2.26.2"; # mapml
    hash = "sha256-RHTPzy0f3DP6ye94Slw/Tz/GIleAgW1DMiMkkneT7kk="; # mapml
  };

  mbstyle = mkGeoserverExtension {
    name = "mbstyle";
    version = "2.26.2"; # mbstyle
    hash = "sha256-vJB9wFiMJtu16JuJ+vESYG07U/Hs7NmMo3kqMkjV0k4="; # mbstyle
  };

  metadata = mkGeoserverExtension {
    name = "metadata";
    version = "2.26.2"; # metadata
    hash = "sha256-CVp2KVHmqeIXPf031HBnvilcgfEKOpyv9Pc/yNpCFM8="; # metadata
  };

  mongodb = mkGeoserverExtension {
    name = "mongodb";
    version = "2.26.2"; # mongodb
    hash = "sha256-Ndo0/r0maxZ7GcGQFY8ZNgtmxXaDJ1Gtj4oDRN7qzWM="; # mongodb
  };

  monitor = mkGeoserverExtension {
    name = "monitor";
    version = "2.26.2"; # monitor
    hash = "sha256-1/yqmzFaPbntgxB1zXqJIrKCdKJpPzHm30v+Ww/kgXE="; # monitor
  };

  mysql = mkGeoserverExtension {
    name = "mysql";
    version = "2.26.2"; # mysql
    hash = "sha256-QOlAUhXyzpazYk/JJr9IcU1gIVS7iGB6Ly2HgbER8dA="; # mysql
  };

  netcdf = mkGeoserverExtension {
    name = "netcdf";
    version = "2.26.2"; # netcdf
    hash = "sha256-cwe518kyk5vMjjBvHhzmTdZ/G0nT0KEDoQK7GbiAnfQ="; # netcdf
    buildInputs = [ netcdf ];
  };

  netcdf-out = mkGeoserverExtension {
    name = "netcdf-out";
    version = "2.26.2"; # netcdf-out
    hash = "sha256-/u9cOOT0/FvEt39VXO3l4Vv01Qpiqg9qJnNH4nnUxa0="; # netcdf-out
    buildInputs = [ netcdf ];
  };

  ogr-wfs = mkGeoserverExtension {
    name = "ogr-wfs";
    version = "2.26.2"; # ogr-wfs
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-4Lp9ffQVgug2zP6ikDyDSITqrq8K5wADjNm3ArpJz1s="; # ogr-wfs
  };

  # Needs ogr-wfs extension.
  ogr-wps = mkGeoserverExtension {
    name = "ogr-wps";
    version = "2.26.2"; # ogr-wps
    # buildInputs = [ pkgs.gdal ];
    hash = "sha256-57rQgsdwXI7eQFhbL+ieP8uOlfeOJqUVWibBNZiPb9E="; # ogr-wps
  };

  oracle = mkGeoserverExtension {
    name = "oracle";
    version = "2.26.2"; # oracle
    hash = "sha256-23/lMh1L3zzwUk3cJCxQhdLdQoghhkK1JAoet9nmN1M="; # oracle
  };

  params-extractor = mkGeoserverExtension {
    name = "params-extractor";
    version = "2.26.2"; # params-extractor
    hash = "sha256-mEKf4riqzSlwra71jY4MO1BM2/fCfikW1CKAB02ntF8="; # params-extractor
  };

  printing = mkGeoserverExtension {
    name = "printing";
    version = "2.26.2"; # printing
    hash = "sha256-/R4MX73aiTGbqDNK+2rthcBUwJesc3j96UDqmpTZpxk="; # printing
  };

  pyramid = mkGeoserverExtension {
    name = "pyramid";
    version = "2.26.2"; # pyramid
    hash = "sha256-6FIDk62d45ctmwhaW/XpdHziiPFyhsKm36l5BpZa4/w="; # pyramid
  };

  querylayer = mkGeoserverExtension {
    name = "querylayer";
    version = "2.26.2"; # querylayer
    hash = "sha256-sM9OmWKJwOjxqzuhOEF+6j01r3+lvvZmaOIxBnmsUbo="; # querylayer
  };

  sldservice = mkGeoserverExtension {
    name = "sldservice";
    version = "2.26.2"; # sldservice
    hash = "sha256-aKRy0wbx5XRdXPGZFsf+bdxmU0ILAPiMI2Zqg2nu52E="; # sldservice
  };

  sqlserver = mkGeoserverExtension {
    name = "sqlserver";
    version = "2.26.2"; # sqlserver
    hash = "sha256-Sacng3WZ+bbljlnYQfP9RWk96kVeiJlGFFgudNheg9g="; # sqlserver
  };

  vectortiles = mkGeoserverExtension {
    name = "vectortiles";
    version = "2.26.2"; # vectortiles
    hash = "sha256-6hC8YfGbgUC6Mxx5/0qfbKOaO7UmHEhcrY9q1U/Q3Us="; # vectortiles
  };

  wcs2_0-eo = mkGeoserverExtension {
    name = "wcs2_0-eo";
    version = "2.26.2"; # wcs2_0-eo
    hash = "sha256-u433otfuIdCOPON8mGcyDgVoHstXV4tKClRopN+yJHE="; # wcs2_0-eo
  };

  web-resource = mkGeoserverExtension {
    name = "web-resource";
    version = "2.26.2"; # web-resource
    hash = "sha256-C8+8Ri7RLz8UhsMuhINF2p7SriHV6+lU/DBMBo75fUw="; # web-resource
  };

  wmts-multi-dimensional = mkGeoserverExtension {
    name = "wmts-multi-dimensional";
    version = "2.26.2"; # wmts-multi-dimensional
    hash = "sha256-6Wnf4im1fZULjoSOu2V3Phn4/6A3UGnCP8BvZDtaKUU="; # wmts-multi-dimensional
  };

  wps = mkGeoserverExtension {
    name = "wps";
    version = "2.26.2"; # wps
    hash = "sha256-ocFmcaWsEq7iothnc7/7DIPpbCo5z5WwI3F1tbDX8dA="; # wps
  };

  # Needs hazelcast (https://github.com/hazelcast/hazelcast (?)) which is not
  # available in nixpgs as of 2024/01.
  #wps-cluster-hazelcast = mkGeoserverExtension {
  #  name = "wps-cluster-hazelcast";
  #  version = "2.26.2"; # wps-cluster-hazelcast
  #  hash = "sha256-GoSeXKd4wBhYdnGlHgoHiaVxnb4VNEg1TG5IXG0qJzA="; # wps-cluster-hazelcast
  #};

  wps-download = mkGeoserverExtension {
    name = "wps-download";
    version = "2.26.2"; # wps-download
    hash = "sha256-FBVt/B2nuf0PY4o1yuJ997sjWdsWYYxDgC94yOKQH/8="; # wps-download
  };

  # Needs Postrgres configuration or similar.
  # See https://docs.geoserver.org/main/en/user/extensions/wps-jdbc/index.html
  wps-jdbc = mkGeoserverExtension {
    name = "wps-jdbc";
    version = "2.26.2"; # wps-jdbc
    hash = "sha256-w3pzprk4UG4vE6K7tB/41U66OGSpB9uNUafKmKZ5uWY="; # wps-jdbc
  };

  ysld = mkGeoserverExtension {
    name = "ysld";
    version = "2.26.2"; # ysld
    hash = "sha256-guaTT3S0lU6nSaw90gNCHm5Gsdc27jX+XE/92vVfVQI="; # ysld
  };

}
