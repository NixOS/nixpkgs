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
    version = "2.26.1"; # app-schema
    hash = "sha256-klT03jure+ILuQX5X3jdIfUa7AI/bdzTEig2QDs/P5o="; # app-schema
  };

  authkey = mkGeoserverExtension {
    name = "authkey";
    version = "2.26.1"; # authkey
    hash = "sha256-jjZtUiSQ8ZzsLrinT8Uw628jIRKnGi6XnGT/5GvCwew="; # authkey
  };

  cas = mkGeoserverExtension {
    name = "cas";
    version = "2.26.1"; # cas
    hash = "sha256-FcUlQ9gSb64wxnEZaU1oJViPDbA32GChcdiZ5uvft7w="; # cas
  };

  charts = mkGeoserverExtension {
    name = "charts";
    version = "2.26.1"; # charts
    hash = "sha256-IDGBTMa+VMqZIxOFylL29t0h9AoOXe7GJmj3dKrdGQ0="; # charts
  };

  control-flow = mkGeoserverExtension {
    name = "control-flow";
    version = "2.26.1"; # control-flow
    hash = "sha256-09EuvTTGeaNRLKshhsyHPvE4p9F5IJPV/ig8cNigQbA="; # control-flow
  };

  css = mkGeoserverExtension {
    name = "css";
    version = "2.26.1"; # css
    hash = "sha256-Qy5AYnXIcsoGxnGCjHRK4XiDflT1jVoVKr6Iq/GMYlg="; # css
  };

  csw = mkGeoserverExtension {
    name = "csw";
    version = "2.26.1"; # csw
    hash = "sha256-mZ7BrWFmLrpzW/oM0YovTC+Zb6BMnj1idMSiemNX6Xc="; # csw
  };

  csw-iso = mkGeoserverExtension {
    name = "csw-iso";
    version = "2.26.1"; # csw-iso
    hash = "sha256-FV5GDv+fywFhdNJi5hT5qvvPQVBT3TJpjI0SQnmH5BY="; # csw-iso
  };

  db2 = mkGeoserverExtension {
    name = "db2";
    version = "2.26.1"; # db2
    hash = "sha256-XlCAFADr8hLFQAbCxrFtrNIBh4S4oEjbezlCwprW8uQ="; # db2
  };

  # Needs wps extension.
  dxf = mkGeoserverExtension {
    name = "dxf";
    version = "2.26.1"; # dxf
    hash = "sha256-WHuhp+nqO5NemYWGiRcuD5/vlBdmMNT+sdm2a+yk9do="; # dxf
  };

  excel = mkGeoserverExtension {
    name = "excel";
    version = "2.26.1"; # excel
    hash = "sha256-JRNM+JilMODNb2r4XEBRj2wkIb/zc6e6Q+U+/X8egAY="; # excel
  };

  feature-pregeneralized = mkGeoserverExtension {
    name = "feature-pregeneralized";
    version = "2.26.1"; # feature-pregeneralized
    hash = "sha256-I0UzMFkZF9SaIFI+GcfegxdC4IFIUi6+GsutotJ5i1Q="; # feature-pregeneralized
  };

  # Note: The extension name ("gdal") clashes with pkgs.gdal.
  gdal = mkGeoserverExtension {
    name = "gdal";
    version = "2.26.1"; # gdal
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-EoaKKlEhch5/wg4SODx9JV9+M+4Ui9Wcb2HSM1bcgLE="; # gdal
  };

  # Throws "java.io.FileNotFoundException: URL [jar:file:/nix/store/.../WEB-INF/lib/gs-geofence-server-2.24.1.jar!/geofence-default-override.properties] cannot be resolved to absolute file path because it does not reside in the file system: jar:file:/nix/store/.../WEB-INF/lib/gs-geofence-server-2.24.1.jar!/geofence-default-override.properties" but seems to work out of the box.
  #geofence = mkGeoserverExtension {
  #  name = "geofence";
  #  version = "2.26.1"; # geofence
  #  hash = "sha256-B2yPPEOsdBDxO/mG3W6MYBqhigjvS6YTZTsvHoUzBAg="; # geofence
  #};

  #geofence-server = mkGeoserverExtension {
  #  name = "geofence-server";
  #  version = "2.26.1"; # geofence-server
  #  hash = "sha256-pgWWomyBmru2tfQfuGdomQirN0Km3j5W/JG644vNHZQ="; # geofence-server
  #};

  #geofence-wps = mkGeoserverExtension {
  #  name = "geofence-wps";
  #  version = "2.26.1"; # geofence-wps
  #  hash = "sha256-hQBYJ+jXx3/GOVzqcSS1w/Zc0GKAD2fyIX5lm9kiPmg="; # geofence-wps
  #};

  geopkg-output = mkGeoserverExtension {
    name = "geopkg-output";
    version = "2.26.1"; # geopkg-output
    hash = "sha256-9EuI9Hvvxdf1FmJ6AMHmbc5RJr33MlBbGd9NqNwacFo="; # geopkg-output
  };

  grib = mkGeoserverExtension {
    name = "grib";
    version = "2.26.1"; # grib
    hash = "sha256-o87Fyy+remmP8c3m4TZ6TX+lUoPdH//P2yJ1DeV+iBs="; # grib
    buildInputs = [ netcdf ];
  };

  gwc-s3 = mkGeoserverExtension {
    name = "gwc-s3";
    version = "2.26.1"; # gwc-s3
    hash = "sha256-7XLrG4sJ1Bvw6d0qzT0ZGLVQ8wr9br9mUEwZGvd9U+s="; # gwc-s3
  };

  h2 = mkGeoserverExtension {
    name = "h2";
    version = "2.26.1"; # h2
    hash = "sha256-ldqz1tPPJkyJPFBeltDUIDLwZtTu8mpSHRbWGsY3TfY="; # h2
  };

  iau = mkGeoserverExtension {
    name = "iau";
    version = "2.26.1"; # iau
    hash = "sha256-mzkYYPfixrSx7+r0lSrOw9agocpi7BogDnmcqtiJh1M="; # iau
  };

  importer = mkGeoserverExtension {
    name = "importer";
    version = "2.26.1"; # importer
    hash = "sha256-Os7oRg+EM5p7rXyI5Qg0vWzZ2i1/tplw1zHaLJJ0feM="; # importer
  };

  inspire = mkGeoserverExtension {
    name = "inspire";
    version = "2.26.1"; # inspire
    hash = "sha256-cYxoBk/oOjKj7gk4mzHUSU1LbWLRxjSbH9B+JiZCxgU="; # inspire
  };

  # Needs Kakadu plugin from
  # https://github.com/geosolutions-it/imageio-ext
  #jp2k = mkGeoserverExtension {
  #  name = "jp2k";
  #  version = "2.26.1"; # jp2k
  #  hash = "sha256-P4UUtfRSlH4GMpDcvy1TjyorolrPLK0P8zCwDJUbFhE="; # jp2k
  #};

  libjpeg-turbo = mkGeoserverExtension {
    name = "libjpeg-turbo";
    version = "2.26.1"; # libjpeg-turbo
    hash = "sha256-pGorlT/BaS605wyIcgNAM5aJxV6I78Dr3m1uADxdebI="; # libjpeg-turbo
    buildInputs = [ libjpeg.out ];
  };

  mapml = mkGeoserverExtension {
    name = "mapml";
    version = "2.26.1"; # mapml
    hash = "sha256-r1Z7Gc3c/kH2jm6wD46Oj2ZZTg136k2n9lqnRVkPXfs="; # mapml
  };

  mbstyle = mkGeoserverExtension {
    name = "mbstyle";
    version = "2.26.1"; # mbstyle
    hash = "sha256-a5jQDyn/nOS/HbhAzKAKl40g1SDYQ51Xi+LzWtByntA="; # mbstyle
  };

  metadata = mkGeoserverExtension {
    name = "metadata";
    version = "2.26.1"; # metadata
    hash = "sha256-O9/gBrJBp8/fOYOx7fsqkgcQ0k6wxIoz9DLQDemjJK8="; # metadata
  };

  mongodb = mkGeoserverExtension {
    name = "mongodb";
    version = "2.26.1"; # mongodb
    hash = "sha256-j9e2V6UkagW55WKKW2eaCnBBGwKmdDjGQBSvngpAqb8="; # mongodb
  };

  monitor = mkGeoserverExtension {
    name = "monitor";
    version = "2.26.1"; # monitor
    hash = "sha256-CLTtJHO+/Hq8/JFErm3ieyLc6wIqCelx0CRDpzbPfZ0="; # monitor
  };

  mysql = mkGeoserverExtension {
    name = "mysql";
    version = "2.26.1"; # mysql
    hash = "sha256-TiSkHdp/U9P1acaD5mN0eOA/J/5fnnJH14nDlKNY3+k="; # mysql
  };

  netcdf = mkGeoserverExtension {
    name = "netcdf";
    version = "2.26.1"; # netcdf
    hash = "sha256-k/zDVoh19Pg/jZa4svAqU1c4EqPnPRSIQL9ZTlrohvY="; # netcdf
    buildInputs = [ netcdf ];
  };

  netcdf-out = mkGeoserverExtension {
    name = "netcdf-out";
    version = "2.26.1"; # netcdf-out
    hash = "sha256-maHIpPQshEcB7JZuhTIo1X209o29iv36alUx76LWV2I="; # netcdf-out
    buildInputs = [ netcdf ];
  };

  ogr-wfs = mkGeoserverExtension {
    name = "ogr-wfs";
    version = "2.26.1"; # ogr-wfs
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-XFEO0JruZCgYj7LWNftIFeI0LoypMbtD2A148LbLg+4="; # ogr-wfs
  };

  # Needs ogr-wfs extension.
  ogr-wps = mkGeoserverExtension {
    name = "ogr-wps";
    version = "2.26.1"; # ogr-wps
    # buildInputs = [ pkgs.gdal ];
    hash = "sha256-qfuU/HlVTHjPIA9DCdc8YURpLyPHSxXKEko0s3tDLpI="; # ogr-wps
  };

  oracle = mkGeoserverExtension {
    name = "oracle";
    version = "2.26.1"; # oracle
    hash = "sha256-dZ6b+hYD1uJDHMJRDChsZc3W9TiQhKfvCBbDIr9xB9E="; # oracle
  };

  params-extractor = mkGeoserverExtension {
    name = "params-extractor";
    version = "2.26.1"; # params-extractor
    hash = "sha256-7qr+jxo4tzxW76k/t+Zd0h45U6mqzReRjnsJfWFZV8o="; # params-extractor
  };

  printing = mkGeoserverExtension {
    name = "printing";
    version = "2.26.1"; # printing
    hash = "sha256-jXdp0zX5sq4HBs1lF658FtSRjMOm1KXrbVm9dDPDmfk="; # printing
  };

  pyramid = mkGeoserverExtension {
    name = "pyramid";
    version = "2.26.1"; # pyramid
    hash = "sha256-hRc24f5pY94TRsmttc0SLPjS6S23kzCeiyuE8XbM4pA="; # pyramid
  };

  querylayer = mkGeoserverExtension {
    name = "querylayer";
    version = "2.26.1"; # querylayer
    hash = "sha256-7wNSoi6PUZJLHGUO0D48O88xKoU63FBSH4+lfxgbEjA="; # querylayer
  };

  sldservice = mkGeoserverExtension {
    name = "sldservice";
    version = "2.26.1"; # sldservice
    hash = "sha256-T2v42w8mhaFH/gcnJUEJdlQZH6gNyx8Y8wpKws0Xsns="; # sldservice
  };

  sqlserver = mkGeoserverExtension {
    name = "sqlserver";
    version = "2.26.1"; # sqlserver
    hash = "sha256-gQrmBMxosWkvAb9+DG9UEgrmG8AKl3NPgYLZ2nG2iM0="; # sqlserver
  };

  vectortiles = mkGeoserverExtension {
    name = "vectortiles";
    version = "2.26.1"; # vectortiles
    hash = "sha256-/cR7S5dzR8td7dFk05QkLnp0vhSpXuCLO0vmiB2JyRQ="; # vectortiles
  };

  wcs2_0-eo = mkGeoserverExtension {
    name = "wcs2_0-eo";
    version = "2.26.1"; # wcs2_0-eo
    hash = "sha256-SYUo3G/BuILOHN6t8F9Q/gwGjAzCY9crmvU+f6mDm/U="; # wcs2_0-eo
  };

  web-resource = mkGeoserverExtension {
    name = "web-resource";
    version = "2.26.1"; # web-resource
    hash = "sha256-z2Zm4UvigN7TvIIHnn42xThIg8Xy3F2+1fPzdhDMZ+A="; # web-resource
  };

  wmts-multi-dimensional = mkGeoserverExtension {
    name = "wmts-multi-dimensional";
    version = "2.26.1"; # wmts-multi-dimensional
    hash = "sha256-Wju8vN4KCN13aJshPqfUEQa8B0WHdeOvFEZ/ZzZOg7E="; # wmts-multi-dimensional
  };

  wps = mkGeoserverExtension {
    name = "wps";
    version = "2.26.1"; # wps
    hash = "sha256-Yi1MdBWeoNBMco/8JUouVXVpfebmpXkTo6COJPLl0bw="; # wps
  };

  # Needs hazelcast (https://github.com/hazelcast/hazelcast (?)) which is not
  # available in nixpgs as of 2024/01.
  #wps-cluster-hazelcast = mkGeoserverExtension {
  #  name = "wps-cluster-hazelcast";
  #  version = "2.26.1"; # wps-cluster-hazelcast
  #  hash = "sha256-Ed2jV6fmoOUQX7Cs3Qe1TjJ8mki/u1v/nng7MqF+Jqs="; # wps-cluster-hazelcast
  #};

  wps-download = mkGeoserverExtension {
    name = "wps-download";
    version = "2.26.1"; # wps-download
    hash = "sha256-HX+RUZHsfyMb/u/I2S57zrW6HKhzSdE9CZT3GjQ0fbM="; # wps-download
  };

  # Needs Postrgres configuration or similar.
  # See https://docs.geoserver.org/main/en/user/extensions/wps-jdbc/index.html
  wps-jdbc = mkGeoserverExtension {
    name = "wps-jdbc";
    version = "2.26.1"; # wps-jdbc
    hash = "sha256-W6EUZtt8It1u786eFvuw9k7eZ1SLBG+J4amW036PZko="; # wps-jdbc
  };

  ysld = mkGeoserverExtension {
    name = "ysld";
    version = "2.26.1"; # ysld
    hash = "sha256-kwAMkoSNxoraZ20fVg0xCOD3slxAITL+eLOIJCGewXk="; # ysld
  };

}
