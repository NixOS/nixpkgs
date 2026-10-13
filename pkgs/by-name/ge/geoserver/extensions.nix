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
    version = "2.28.4"; # app-schema
    hash = "sha256-qgzJP8m3CnkZHlM3Wmix9wl8M0G9m8DTJZ8HcBJx/aw="; # app-schema
  };

  authkey = mkGeoserverExtension {
    name = "authkey";
    version = "2.28.4"; # authkey
    hash = "sha256-UDRVVPGqhCwen/irMz8YUbv01PQ4oRFJgELtzvJ6WGk="; # authkey
  };

  cas = mkGeoserverExtension {
    name = "cas";
    version = "2.28.4"; # cas
    hash = "sha256-g0BqPXtRoIYfLps6cFCg/+DBYOZpQX/bolJcwGuCTaI="; # cas
  };

  charts = mkGeoserverExtension {
    name = "charts";
    version = "2.28.4"; # charts
    hash = "sha256-vhFVGX64M+5NfHYBNj1yMadZ2bKLwemURjwd6jp2HPM="; # charts
  };

  control-flow = mkGeoserverExtension {
    name = "control-flow";
    version = "2.28.4"; # control-flow
    hash = "sha256-FJj8g145s1qOoym+5SQymcSzH8bTzthUg5dWIR7ZGPU="; # control-flow
  };

  css = mkGeoserverExtension {
    name = "css";
    version = "2.28.4"; # css
    hash = "sha256-9BYc4j1fk5hTT4jKdHReaoSg7bWjxmyUrOdwMospiiM="; # css
  };

  csw = mkGeoserverExtension {
    name = "csw";
    version = "2.28.4"; # csw
    hash = "sha256-/+IQO/X26cMz5+aOtMDJ23ovjnmOOATSgRNs40bzM0I="; # csw
  };

  csw-iso = mkGeoserverExtension {
    name = "csw-iso";
    version = "2.28.4"; # csw-iso
    hash = "sha256-kmUH2g18/PXBTl2cUzs2q1fzSn6BllikvatRgNlxRtc="; # csw-iso
  };

  db2 = mkGeoserverExtension {
    name = "db2";
    version = "2.28.4"; # db2
    hash = "sha256-4xeE1Y6PXqlt7LCz5s86+Uj6JMV2HqrmJpIAR6pnQhk="; # db2
  };

  # Needs wps extension.
  dxf = mkGeoserverExtension {
    name = "dxf";
    version = "2.28.4"; # dxf
    hash = "sha256-lfvvlennN7Ig0sV2ujAi3KpLmgqFSf1Y5m6pcpSc2wY="; # dxf
  };

  excel = mkGeoserverExtension {
    name = "excel";
    version = "2.28.4"; # excel
    hash = "sha256-VSh9rNAnJzbfEYKELY1BRcoHRtifk3J0D08ZnF5+kTc="; # excel
  };

  feature-pregeneralized = mkGeoserverExtension {
    name = "feature-pregeneralized";
    version = "2.28.4"; # feature-pregeneralized
    hash = "sha256-ZY7Qr3faGZOFg7zX4JFJ+FdSIhXQ1ROulcPRmGRGyAI="; # feature-pregeneralized
  };

  # Note: The extension name ("gdal") clashes with pkgs.gdal.
  gdal = mkGeoserverExtension {
    name = "gdal";
    version = "2.28.4"; # gdal
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-7GT6XfpDjCX+TYprg4Y59UshSYa0tACIFQrtPW8vrFM="; # gdal
  };

  # Throws "java.io.FileNotFoundException: URL [jar:file:/nix/store/.../WEB-INF/lib/gs-geofence-server-2.24.1.jar!/geofence-default-override.properties] cannot be resolved to absolute file path because it does not reside in the file system: jar:file:/nix/store/.../WEB-INF/lib/gs-geofence-server-2.24.1.jar!/geofence-default-override.properties" but seems to work out of the box.
  #geofence = mkGeoserverExtension {
  #  name = "geofence";
  #  version = "2.28.4"; # geofence
  #  hash = "sha256-620nYoPkM1GitY221F/uN9Ts8D9h7DBvXf9DAxoUGBY="; # geofence
  #};

  #geofence-server-h2 = mkGeoserverExtension {
  #  name = "geofence-server-h2";
  #  version = "2.28.4"; # geofence-server
  #  hash = "sha256-KL4VTHZ3/kfCBkvAKgCmXs+TVa2Z4Zb+UphRyVnZI2I="; # geofence-server-h2
  #};

  #geofence-server-postgres = mkGeoserverExtension {
  #  name = "geofence-server-postgres";
  #  version = "2.28.4"; # geofence-server
  #  hash = "sha256-7EVrhV6vbglGd15K81Ypygu+1tEYtZOy9wsERBu4sNM="; # geofence-server-postgres
  #};

  #geofence-wps = mkGeoserverExtension {
  #  name = "geofence-wps";
  #  version = "2.28.4"; # geofence-wps
  #  hash = "sha256-7yVXODL1Fx0KM4BSeHCa4Fw/+xE7j9LJtdpVLeWPOI8="; # geofence-wps
  #};

  geopkg-output = mkGeoserverExtension {
    name = "geopkg-output";
    version = "2.28.4"; # geopkg-output
    hash = "sha256-2CbA5opqZwwKBcM87nbY9e/i67vs70SShW08Fpryy8o="; # geopkg-output
  };

  grib = mkGeoserverExtension {
    name = "grib";
    version = "2.28.4"; # grib
    hash = "sha256-apCBtt1SOB8rimpUDny6KOjxzwMjCk+E3vdpv336iJE="; # grib
    buildInputs = [ netcdf ];
  };

  gwc-s3 = mkGeoserverExtension {
    name = "gwc-s3";
    version = "2.28.4"; # gwc-s3
    hash = "sha256-Jy3/EFNJym61st2LAysgRKsS2KBTFhkFSZc6WouO3LA="; # gwc-s3
  };

  h2 = mkGeoserverExtension {
    name = "h2";
    version = "2.28.4"; # h2
    hash = "sha256-tqchE8kkyo35rL9ESs/TD8n9CWAaWiWqe3wxKXt3Ut4="; # h2
  };

  iau = mkGeoserverExtension {
    name = "iau";
    version = "2.28.4"; # iau
    hash = "sha256-yorqFxLh9PWoC0j4WXwXs5uK1sy2gV9S1vS36ebKBIc="; # iau
  };

  importer = mkGeoserverExtension {
    name = "importer";
    version = "2.28.4"; # importer
    hash = "sha256-XGCVD/CUZjiPCzLyHec7na+fNARkBvnfR1+GbCdogXQ="; # importer
  };

  inspire = mkGeoserverExtension {
    name = "inspire";
    version = "2.28.4"; # inspire
    hash = "sha256-/9juMAOOCycPeJcuB9a3DMIC8xzN1WjrzEi951utodg="; # inspire
  };

  # Needs Kakadu plugin from
  # https://github.com/geosolutions-it/imageio-ext
  #jp2k = mkGeoserverExtension {
  #  name = "jp2k";
  #  version = "2.28.4"; # jp2k
  #  hash = "sha256-IfGThXCIEkmoTlA3EdIWekFDGBw3K+yqO49RZFDfAeQ="; # jp2k
  #};

  # Throws "java.lang.UnsatisfiedLinkError: 'void org.libjpegturbo.turbojpeg.TJDecompressor.init()'"
  # as of 2.28.1.
  # NOTE: When re-enabling this, RE-ENABLE THE CORRESPONDING TEST, TOO! (See tests/geoserver.nix)
  #libjpeg-turbo = mkGeoserverExtension {
  #  name = "libjpeg-turbo";
  #  version = "2.28.4"; # libjpeg-turbo
  #  hash = "sha256-05aP0WypGM0dz/OXM/1paYgmmwGGcU7j34kYdJIlL0U="; # libjpeg-turbo
  #  buildInputs = [ libjpeg.out ];
  #};

  mapml = mkGeoserverExtension {
    name = "mapml";
    version = "2.28.4"; # mapml
    hash = "sha256-fZVPUqUlNx2xvh9qEJgIX+rfvT2ZeLjb8SgTEdYC4FI="; # mapml
  };

  mbstyle = mkGeoserverExtension {
    name = "mbstyle";
    version = "2.28.4"; # mbstyle
    hash = "sha256-OHEJ5u1r4KcikluRjah1S137IjbDDtGtVQQbqczjoco="; # mbstyle
  };

  metadata = mkGeoserverExtension {
    name = "metadata";
    version = "2.28.4"; # metadata
    hash = "sha256-pL1Xti6+TUPN0ujpJjGRt26q3ItEKQa37loNpmQvwVs="; # metadata
  };

  mongodb = mkGeoserverExtension {
    name = "mongodb";
    version = "2.28.4"; # mongodb
    hash = "sha256-XwQAKp6XZH3W4qsNjhmA73hf6SjINz9/SOPwb2wGdcU="; # mongodb
  };

  monitor = mkGeoserverExtension {
    name = "monitor";
    version = "2.28.4"; # monitor
    hash = "sha256-JhmsDRoHGbTBCKxKqlxdpmn2WGC/aQnyeuWLs1u0xFE="; # monitor
  };

  mysql = mkGeoserverExtension {
    name = "mysql";
    version = "2.28.4"; # mysql
    hash = "sha256-f8xdJ2WVYQV+HG5U2J/1vKBAFo5srFWSPXVAyRUt8kE="; # mysql
  };

  netcdf = mkGeoserverExtension {
    name = "netcdf";
    version = "2.28.4"; # netcdf
    hash = "sha256-wU5MkTYgxxOgBBybbbeHtT2Rj1CoTFBTjGzyLPlPT7A="; # netcdf
    buildInputs = [ netcdf ];
  };

  netcdf-out = mkGeoserverExtension {
    name = "netcdf-out";
    version = "2.28.4"; # netcdf-out
    hash = "sha256-0RIRTDtTUEj9OUDpAD1LbCY1iGCbXAKbgmH7ZkNHWhM="; # netcdf-out
    buildInputs = [ netcdf ];
  };

  ogr-wfs = mkGeoserverExtension {
    name = "ogr-wfs";
    version = "2.28.4"; # ogr-wfs
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-UAsTKEMVlYTrCpbs8++Kxdn0w6ejzMiPrT7S2NlMNxc="; # ogr-wfs
  };

  # Needs ogr-wfs extension.
  ogr-wps = mkGeoserverExtension {
    name = "ogr-wps";
    version = "2.28.4"; # ogr-wps
    # buildInputs = [ pkgs.gdal ];
    hash = "sha256-sjV0YwR21GQYt4YuDIE2H+5UQ2qRmP7tWVyOXNuLkSM="; # ogr-wps
  };

  oracle = mkGeoserverExtension {
    name = "oracle";
    version = "2.28.4"; # oracle
    hash = "sha256-xiIPgpWCDycE6rTW49QnB/7rHbns1GJhWCdIfMEBuXE="; # oracle
  };

  params-extractor = mkGeoserverExtension {
    name = "params-extractor";
    version = "2.28.4"; # params-extractor
    hash = "sha256-/AOjfsA58btiOBv4zvF4jdLt2lE5GPDKUKzNZyX8fI0="; # params-extractor
  };

  printing = mkGeoserverExtension {
    name = "printing";
    version = "2.28.4"; # printing
    hash = "sha256-smytiUVPKq31YyWE/xLwiGPLQ6DxScj2gHjMbgKCjMc="; # printing
  };

  pyramid = mkGeoserverExtension {
    name = "pyramid";
    version = "2.28.4"; # pyramid
    hash = "sha256-xfOzBm5eTbzfRRiMQ63i29GW91IxWKIotrSUa6BgD5M="; # pyramid
  };

  querylayer = mkGeoserverExtension {
    name = "querylayer";
    version = "2.28.4"; # querylayer
    hash = "sha256-WyLyUoLfv8JIKBqjphcXgWBbtkJEB3ig4cyY158lRQk="; # querylayer
  };

  sldservice = mkGeoserverExtension {
    name = "sldservice";
    version = "2.28.4"; # sldservice
    hash = "sha256-DsN9tKZshcsz6/IsPA0l757YtmsakBi/NbgEUwnfafs="; # sldservice
  };

  sqlserver = mkGeoserverExtension {
    name = "sqlserver";
    version = "2.28.4"; # sqlserver
    hash = "sha256-MBMU4pJKgS3qra9pli8SAnOtIiDU2zD0sXJaKXlr0+A="; # sqlserver
  };

  vectortiles = mkGeoserverExtension {
    name = "vectortiles";
    version = "2.28.4"; # vectortiles
    hash = "sha256-6E3lwH573lTSMYtQ00b3fVtJYSsIFETwT7JAZHI6ubQ="; # vectortiles
  };

  wcs2_0-eo = mkGeoserverExtension {
    name = "wcs2_0-eo";
    version = "2.28.4"; # wcs2_0-eo
    hash = "sha256-w30lrzli6++7NDu59QsRFxyIQBMSV7M5BeTqGSJmw18="; # wcs2_0-eo
  };

  web-resource = mkGeoserverExtension {
    name = "web-resource";
    version = "2.28.4"; # web-resource
    hash = "sha256-GH0foPjbBcKOXahqgPv+02Jex3ZE5XKmeWNDew0DKF4="; # web-resource
  };

  wmts-multi-dimensional = mkGeoserverExtension {
    name = "wmts-multi-dimensional";
    version = "2.28.4"; # wmts-multi-dimensional
    hash = "sha256-gi8qwwKG9K1l4AJ05vDGykxCmd42oSFSZtwhDwDI8m0="; # wmts-multi-dimensional
  };

  wps = mkGeoserverExtension {
    name = "wps";
    version = "2.28.4"; # wps
    hash = "sha256-2qh7fDeJAswTb+P60zNQeH1nc0886Dfh7pWpUWCaEKc="; # wps
  };

  # Needs hazelcast (https://github.com/hazelcast/hazelcast (?)) which is not
  # available in nixpgs as of 2024/01.
  #wps-cluster-hazelcast = mkGeoserverExtension {
  #  name = "wps-cluster-hazelcast";
  #  version = "2.28.4"; # wps-cluster-hazelcast
  #  hash = "sha256-r9BpjvFL00lgTrbhIxY7c16sGu6ujKJ6D4oDz61KekA="; # wps-cluster-hazelcast
  #};

  wps-download = mkGeoserverExtension {
    name = "wps-download";
    version = "2.28.4"; # wps-download
    hash = "sha256-MAL71aYRKOFSKnhj+3dxZhCDQL/6GAeAtB11Zs6C5tI="; # wps-download
  };

  # Needs Postrgres configuration or similar.
  # See https://docs.geoserver.org/main/en/user/extensions/wps-jdbc/index.html
  wps-jdbc = mkGeoserverExtension {
    name = "wps-jdbc";
    version = "2.28.4"; # wps-jdbc
    hash = "sha256-QBydO6EKLe22W+3pCP4p9TqMyp1KeKReyeidL5yxndo="; # wps-jdbc
  };

  ysld = mkGeoserverExtension {
    name = "ysld";
    version = "2.28.4"; # ysld
    hash = "sha256-Qg+wzMzRebqqOAK4Y7hsfcTyKcz/E5Fw/fHLcUr3KwY="; # ysld
  };

}
