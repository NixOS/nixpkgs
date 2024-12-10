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
    version = "2.26.0"; # app-schema
    hash = "sha256-HOjhM9WI7lsqUNrozLB2oI6szqm+Cb7VqC0Hy9NlNMU="; # app-schema
  };

  authkey = mkGeoserverExtension {
    name = "authkey";
    version = "2.26.0"; # authkey
    hash = "sha256-34U3zq/SKm21fZV80+04N/0ygqShdYVMeQNuqtMSXgQ="; # authkey
  };

  cas = mkGeoserverExtension {
    name = "cas";
    version = "2.26.0"; # cas
    hash = "sha256-mosawsZkCKOm03CFg9poJ+XwbbGhvNt8AsxnegW59H4="; # cas
  };

  charts = mkGeoserverExtension {
    name = "charts";
    version = "2.26.0"; # charts
    hash = "sha256-rPnY9zYgdRoud2I2hcxnODDE/2gsBTMgTPrGAwDdrbM="; # charts
  };

  control-flow = mkGeoserverExtension {
    name = "control-flow";
    version = "2.26.0"; # control-flow
    hash = "sha256-4Kl0SgKW8MifMVY1+Aa9Ve0WufjHFQejobhQfnwGwbw="; # control-flow
  };

  css = mkGeoserverExtension {
    name = "css";
    version = "2.26.0"; # css
    hash = "sha256-CUG5cBxW/PyP/M2I5/1wC1UndzWSIg8aKeETtUnrH5A="; # css
  };

  csw = mkGeoserverExtension {
    name = "csw";
    version = "2.26.0"; # csw
    hash = "sha256-ABNFf6grpU97nd81H/s8Gfd1G9mxMwVdUduubLWrsRE="; # csw
  };

  csw-iso = mkGeoserverExtension {
    name = "csw-iso";
    version = "2.26.0"; # csw-iso
    hash = "sha256-dKyVP5FuJ0Tl2z4veMeIJO66dBucfZo6qH+WvSBQ1Es="; # csw-iso
  };

  db2 = mkGeoserverExtension {
    name = "db2";
    version = "2.26.0"; # db2
    hash = "sha256-L0Xrc0MuSiezKk7l4P4lm3phRou79neQds4Yu2VG5DY="; # db2
  };

  # Needs wps extension.
  dxf = mkGeoserverExtension {
    name = "dxf";
    version = "2.26.0"; # dxf
    hash = "sha256-OtpYej/MxqeoMBw17Ltr9l5iOGUa91L30hgBz6ZbD+Y="; # dxf
  };

  excel = mkGeoserverExtension {
    name = "excel";
    version = "2.26.0"; # excel
    hash = "sha256-UHIVJnUJnzPDJWsrQw9YasUedpLujKr9s3VJtSgESHY="; # excel
  };

  feature-pregeneralized = mkGeoserverExtension {
    name = "feature-pregeneralized";
    version = "2.26.0"; # feature-pregeneralized
    hash = "sha256-WT1TsHcYoxJK0LWsF4h8VdUGxIecx9SuIqWoA9JjZfA="; # feature-pregeneralized
  };

  # Note: The extension name ("gdal") clashes with pkgs.gdal.
  gdal = mkGeoserverExtension {
    name = "gdal";
    version = "2.26.0"; # gdal
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-lGyBxRCz5DvDQUNQmsk1+DfArwx3kcMoSgQq+O/DqZc="; # gdal
  };

  # Throws "java.io.FileNotFoundException: URL [jar:file:/nix/store/.../WEB-INF/lib/gs-geofence-server-2.24.1.jar!/geofence-default-override.properties] cannot be resolved to absolute file path because it does not reside in the file system: jar:file:/nix/store/.../WEB-INF/lib/gs-geofence-server-2.24.1.jar!/geofence-default-override.properties" but seems to work out of the box.
  #geofence = mkGeoserverExtension {
  #  name = "geofence";
  #  version = "2.26.0"; # geofence
  #  hash = "sha256-Io71mNpUu15klMWFHCaFfRmxPUGGTASZE7MZWyv2TDQ="; # geofence
  #};

  #geofence-server = mkGeoserverExtension {
  #  name = "geofence-server";
  #  version = "2.26.0"; # geofence-server
  #  hash = "sha256-UPRupgj9La/JWAneGeM+UdCvnkcW3ZTe7c1bYZRURGI="; # geofence-server
  #};

  #geofence-wps = mkGeoserverExtension {
  #  name = "geofence-wps";
  #  version = "2.26.0"; # geofence-wps
  #  hash = "sha256-SA7nWTyawzDZVsOATRLW/MQQfyXWhHQif3/4MdVogBM="; # geofence-wps
  #};

  geopkg-output = mkGeoserverExtension {
    name = "geopkg-output";
    version = "2.26.0"; # geopkg-output
    hash = "sha256-SKIInEC9TI2FBtduGHi3apZip5ubA4/ip58+w0O1a38="; # geopkg-output
  };

  grib = mkGeoserverExtension {
    name = "grib";
    version = "2.26.0"; # grib
    hash = "sha256-5Hn6LUxsCP5YvVsMgh6m/oMBJuIo2Y9XdbSRQAJm+vI="; # grib
    buildInputs = [ netcdf ];
  };

  gwc-s3 = mkGeoserverExtension {
    name = "gwc-s3";
    version = "2.26.0"; # gwc-s3
    hash = "sha256-www+MTFlkmJ6GeGd3v8uGTYV7PYVg5pIS9/2s1D6YeU="; # gwc-s3
  };

  h2 = mkGeoserverExtension {
    name = "h2";
    version = "2.26.0"; # h2
    hash = "sha256-+Y7pILmnz51c5eO+OdqHGLD05fEqaM3vkFU7s0UiA2g="; # h2
  };

  iau = mkGeoserverExtension {
    name = "iau";
    version = "2.26.0"; # iau
    hash = "sha256-5oM3JxD6HKVhq1/IxXWck1MtQ8KwsLtf+LQACpvdKMA="; # iau
  };

  importer = mkGeoserverExtension {
    name = "importer";
    version = "2.26.0"; # importer
    hash = "sha256-HFBIEB8pgVaCMF34Z0Clp3+nk2h4Va0xV2ptSZUSx9I="; # importer
  };

  inspire = mkGeoserverExtension {
    name = "inspire";
    version = "2.26.0"; # inspire
    hash = "sha256-uIryr4WQbWdAMjqATGf0txp1sZWWABSMv8o2xiKaWiI="; # inspire
  };

  # Needs Kakadu plugin from
  # https://github.com/geosolutions-it/imageio-ext
  #jp2k = mkGeoserverExtension {
  #  name = "jp2k";
  #  version = "2.26.0"; # jp2k
  #  hash = "sha256-gPipm6hnkIyEU3a8NbSCm5QUSF+IKNHgt5DNFsvC++c="; # jp2k
  #};

  libjpeg-turbo = mkGeoserverExtension {
    name = "libjpeg-turbo";
    version = "2.26.0"; # libjpeg-turbo
    hash = "sha256-I1Ojsgd+gRjSJJkx9wSfzJfVq5z3vgxA4zynZvVd4jU="; # libjpeg-turbo
    buildInputs = [ libjpeg.out ];
  };

  mapml = mkGeoserverExtension {
    name = "mapml";
    version = "2.26.0"; # mapml
    hash = "sha256-VGg/3cB+KUwZtbKQUoU4NURDjcANzQpPv4ZWeCzwkq0="; # mapml
  };

  mbstyle = mkGeoserverExtension {
    name = "mbstyle";
    version = "2.26.0"; # mbstyle
    hash = "sha256-Z5CNKP2fqMcw6prP/b84tOAPYwlLiFsbV26VdVnqFns="; # mbstyle
  };

  metadata = mkGeoserverExtension {
    name = "metadata";
    version = "2.26.0"; # metadata
    hash = "sha256-6E9Z6WqCQxlDL3w1FiI+gOzjQ4ZyS5oucj1/02W4k4Y="; # metadata
  };

  mongodb = mkGeoserverExtension {
    name = "mongodb";
    version = "2.26.0"; # mongodb
    hash = "sha256-thfgMeDrDb2rPh9h9R2AgYYWPBHcEG/sI4UhNBb/DfQ="; # mongodb
  };

  monitor = mkGeoserverExtension {
    name = "monitor";
    version = "2.26.0"; # monitor
    hash = "sha256-vgeqZXzb8nz7daAeur1JMLS0Rospgyx+v9n687000EE="; # monitor
  };

  mysql = mkGeoserverExtension {
    name = "mysql";
    version = "2.26.0"; # mysql
    hash = "sha256-PCNCyqJwOK6P6sDWVMdV6gGXgHJOPw97cqkjaixZxwQ="; # mysql
  };

  netcdf = mkGeoserverExtension {
    name = "netcdf";
    version = "2.26.0"; # netcdf
    hash = "sha256-0i/zmiIE+xjec6dOd237MdIBrCspZEL+8h1c/g0h7oU="; # netcdf
    buildInputs = [ netcdf ];
  };

  netcdf-out = mkGeoserverExtension {
    name = "netcdf-out";
    version = "2.26.0"; # netcdf-out
    hash = "sha256-xl2mY9QYSVeC2k43H2GFz2D56rajCT9FlpP47Q8aOe8="; # netcdf-out
    buildInputs = [ netcdf ];
  };

  ogr-wfs = mkGeoserverExtension {
    name = "ogr-wfs";
    version = "2.26.0"; # ogr-wfs
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-LiB+BE2Q3a2US7HJkBWT0Z9AMZ3A3M584qbEV1uhhEM="; # ogr-wfs
  };

  # Needs ogr-wfs extension.
  ogr-wps = mkGeoserverExtension {
    name = "ogr-wps";
    version = "2.26.0"; # ogr-wps
    # buildInputs = [ pkgs.gdal ];
    hash = "sha256-0o4cD8wv1Km5pljxAlokVRVEfMbklXgkYhxFZqPdROk="; # ogr-wps
  };

  oracle = mkGeoserverExtension {
    name = "oracle";
    version = "2.26.0"; # oracle
    hash = "sha256-mxc46ctIh7imjQgTI2zZ9gwtgDF6GkE/b5IogUktF9Y="; # oracle
  };

  params-extractor = mkGeoserverExtension {
    name = "params-extractor";
    version = "2.26.0"; # params-extractor
    hash = "sha256-dLzEdnNy+Nrxkc4aBCGTESuReW6mkgXEpXDo9rDzsBU="; # params-extractor
  };

  printing = mkGeoserverExtension {
    name = "printing";
    version = "2.26.0"; # printing
    hash = "sha256-31T/tizxkmzYbxR1eLiY3DanwlFVdeZvFOESgBnuG1A="; # printing
  };

  pyramid = mkGeoserverExtension {
    name = "pyramid";
    version = "2.26.0"; # pyramid
    hash = "sha256-lpDexw5nd1jm9cDFsQ/qXdwbX5vTD0RXKIAOg6dKQqE="; # pyramid
  };

  querylayer = mkGeoserverExtension {
    name = "querylayer";
    version = "2.26.0"; # querylayer
    hash = "sha256-ajrNJ0eG0pp+v/f4N5kxcUzYOyXuLhMRzvdfdiJh0Vk="; # querylayer
  };

  sldservice = mkGeoserverExtension {
    name = "sldservice";
    version = "2.26.0"; # sldservice
    hash = "sha256-xxpKSDghK+Xz8buPU5lzEa7eiG5A0rPgzCaIO9GKCMY="; # sldservice
  };

  sqlserver = mkGeoserverExtension {
    name = "sqlserver";
    version = "2.26.0"; # sqlserver
    hash = "sha256-UwZ4ho+HG+ocwri+N4ebTATGcT4tukAxwvx84rP0VWk="; # sqlserver
  };

  vectortiles = mkGeoserverExtension {
    name = "vectortiles";
    version = "2.26.0"; # vectortiles
    hash = "sha256-rlQcWLEPvaKDT6JZ0RuZtaHz1bgtsblFOybKOVqDSVM="; # vectortiles
  };

  wcs2_0-eo = mkGeoserverExtension {
    name = "wcs2_0-eo";
    version = "2.26.0"; # wcs2_0-eo
    hash = "sha256-Ky+unKH+WBMvo/rlNPv2Uca3X610yXZvCy0/5KEN6wk="; # wcs2_0-eo
  };

  web-resource = mkGeoserverExtension {
    name = "web-resource";
    version = "2.26.0"; # web-resource
    hash = "sha256-S7Wu4wGo2j8PcBC8VS7EECBlr7NN1hALC1VOM5b6Wk0="; # web-resource
  };

  wmts-multi-dimensional = mkGeoserverExtension {
    name = "wmts-multi-dimensional";
    version = "2.26.0"; # wmts-multi-dimensional
    hash = "sha256-BNigZB16d1BKRTl/UJs1oWYFKn/cFk5WX1fBwvC046I="; # wmts-multi-dimensional
  };

  wps = mkGeoserverExtension {
    name = "wps";
    version = "2.26.0"; # wps
    hash = "sha256-HVTDMqG23Ign7qottKRo1PtQNr6606nV34SRopAMO1Q="; # wps
  };

  # Needs hazelcast (https://github.com/hazelcast/hazelcast (?)) which is not
  # available in nixpgs as of 2024/01.
  #wps-cluster-hazelcast = mkGeoserverExtension {
  #  name = "wps-cluster-hazelcast";
  #  version = "2.26.0"; # wps-cluster-hazelcast
  #  hash = "sha256-R0Btbf6BNwGKC2TQ6BmSte612Sel7NspOX9KU+zsHBc="; # wps-cluster-hazelcast
  #};

  wps-download = mkGeoserverExtension {
    name = "wps-download";
    version = "2.26.0"; # wps-download
    hash = "sha256-sVbAi0y8n2shox6TX0Y4Hg5GhYakv5+tgloMix6Wbfg="; # wps-download
  };

  # Needs Postrgres configuration or similar.
  # See https://docs.geoserver.org/main/en/user/extensions/wps-jdbc/index.html
  wps-jdbc = mkGeoserverExtension {
    name = "wps-jdbc";
    version = "2.26.0"; # wps-jdbc
    hash = "sha256-iJk24m4UDwK1PrU0PiCDPGj0eK7EEQajUFyl+9aIGpE="; # wps-jdbc
  };

  ysld = mkGeoserverExtension {
    name = "ysld";
    version = "2.26.0"; # ysld
    hash = "sha256-/qbtfaIE/4haGeS6U+FML1JI/AyXWFyKOd8tGaYFCmw="; # ysld
  };

}
