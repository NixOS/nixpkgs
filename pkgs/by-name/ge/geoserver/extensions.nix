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
    version = "2.28.0"; # app-schema
    hash = "sha256-OjRHbl0svweqCaZNXouyB8iuoj5RWkbA3hkeo8/7vh8="; # app-schema
  };

  authkey = mkGeoserverExtension {
    name = "authkey";
    version = "2.28.0"; # authkey
    hash = "sha256-1RLvgJsqgWnRhXOoFLT9/q6DpM1QRoWwqd6yGYeDpfY="; # authkey
  };

  cas = mkGeoserverExtension {
    name = "cas";
    version = "2.28.0"; # cas
    hash = "sha256-1u4atKtT6c97zBLxL82fbaZrSmScBTZ5icZ5S+k149w="; # cas
  };

  charts = mkGeoserverExtension {
    name = "charts";
    version = "2.28.0"; # charts
    hash = "sha256-Yu8m9aA9YfQNlU4yaRLj8u7os19rgFxGp9HlZZDxR24="; # charts
  };

  control-flow = mkGeoserverExtension {
    name = "control-flow";
    version = "2.28.0"; # control-flow
    hash = "sha256-o3mVBRWVydDwtNc15DV5AZTxDEbFi6WnLb0UArBpF/c="; # control-flow
  };

  css = mkGeoserverExtension {
    name = "css";
    version = "2.28.0"; # css
    hash = "sha256-GISCCl6hPVtuOPU3g+NsLB+4w/imQJuO0NTpzCz1hVo="; # css
  };

  csw = mkGeoserverExtension {
    name = "csw";
    version = "2.28.0"; # csw
    hash = "sha256-wGble6LK70xDRPo829BzcV2xa8rzIc6hZLAppoqGCg0="; # csw
  };

  csw-iso = mkGeoserverExtension {
    name = "csw-iso";
    version = "2.28.0"; # csw-iso
    hash = "sha256-25fqlrM+e/Zf/0y/YmFB7tYUp1kWwI9k8Avc2vUbAjQ="; # csw-iso
  };

  db2 = mkGeoserverExtension {
    name = "db2";
    version = "2.28.0"; # db2
    hash = "sha256-frDXB2PW02dU7M+CN6T5gbxi5bV32Umv69mZhejOEp0="; # db2
  };

  # Needs wps extension.
  dxf = mkGeoserverExtension {
    name = "dxf";
    version = "2.28.0"; # dxf
    hash = "sha256-fD69Q4WwrmEI/emXJZv2cfw2jYfnF0caZrn54I+rBwM="; # dxf
  };

  excel = mkGeoserverExtension {
    name = "excel";
    version = "2.28.0"; # excel
    hash = "sha256-sC3CPgO3XCBTJxw5ot+bZm/Cq12l/Q4Ks4W2F0i6EJE="; # excel
  };

  feature-pregeneralized = mkGeoserverExtension {
    name = "feature-pregeneralized";
    version = "2.28.0"; # feature-pregeneralized
    hash = "sha256-cHQJoDYxRhixqeA5UpidCtGnM/svslwSzK/iyR6w2Ww="; # feature-pregeneralized
  };

  # Note: The extension name ("gdal") clashes with pkgs.gdal.
  gdal = mkGeoserverExtension {
    name = "gdal";
    version = "2.28.0"; # gdal
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-eVEMK34pRkwnZBbTYrfD1sgpQz2d0Y07/9vuvy+m8NA="; # gdal
  };

  # Throws "java.io.FileNotFoundException: URL [jar:file:/nix/store/.../WEB-INF/lib/gs-geofence-server-2.24.1.jar!/geofence-default-override.properties] cannot be resolved to absolute file path because it does not reside in the file system: jar:file:/nix/store/.../WEB-INF/lib/gs-geofence-server-2.24.1.jar!/geofence-default-override.properties" but seems to work out of the box.
  #geofence = mkGeoserverExtension {
  #  name = "geofence";
  #  version = "2.28.0"; # geofence
  #  hash = "sha256-tcfaUsK6wLhxXhCSYTs3tWWsNIQMqMyV1S8yPhQFOLc="; # geofence
  #};

  #geofence-server = mkGeoserverExtension {
  #  name = "geofence-server";
  #  version = "2.28.0"; # geofence-server
  #  hash = ""; # geofence-server
  #};

  #geofence-wps = mkGeoserverExtension {
  #  name = "geofence-wps";
  #  version = "2.28.0"; # geofence-wps
  #  hash = "sha256-K/MnHCp38m+S3k5JbcHoyhE1pmUn7At7tl2m0oAUS1g="; # geofence-wps
  #};

  geopkg-output = mkGeoserverExtension {
    name = "geopkg-output";
    version = "2.28.0"; # geopkg-output
    hash = "sha256-qtq0ByNGlyjjio+iYSM6xTvfR/HKrnQRyN76pLTw6n8="; # geopkg-output
  };

  grib = mkGeoserverExtension {
    name = "grib";
    version = "2.28.0"; # grib
    hash = "sha256-ewkOakjtWm1/CDkvbGwR2pTLUvKG/kApytMDPJwB5uk="; # grib
    buildInputs = [ netcdf ];
  };

  gwc-s3 = mkGeoserverExtension {
    name = "gwc-s3";
    version = "2.28.0"; # gwc-s3
    hash = "sha256-683JTAQLAxvLvWbudYqebH3hT412DQ/WFyGtbeMF9nM="; # gwc-s3
  };

  h2 = mkGeoserverExtension {
    name = "h2";
    version = "2.28.0"; # h2
    hash = "sha256-iCkZNA8w480CD5vfnG/q4Bn0dMuiP37gQeJ6TavSTNA="; # h2
  };

  iau = mkGeoserverExtension {
    name = "iau";
    version = "2.28.0"; # iau
    hash = "sha256-z26pAnbx7WIs197uIyfCrDmrtftvFPtUr6itJCSMFPE="; # iau
  };

  importer = mkGeoserverExtension {
    name = "importer";
    version = "2.28.0"; # importer
    hash = "sha256-3EOpBNOHuVhsJIEHVgGM5KZEoBsxWoSiuUcbp2gIF+A="; # importer
  };

  inspire = mkGeoserverExtension {
    name = "inspire";
    version = "2.28.0"; # inspire
    hash = "sha256-kBEu6lkm2BCYipLbJo8ra+l+aeoYNVW3b3h/ZcMUxn0="; # inspire
  };

  # Needs Kakadu plugin from
  # https://github.com/geosolutions-it/imageio-ext
  #jp2k = mkGeoserverExtension {
  #  name = "jp2k";
  #  version = "2.28.0"; # jp2k
  #  hash = "sha256-zocxsJKm63kEThYtQ5QNhJ054hQxPdGJjX9CRQ6M4zQ="; # jp2k
  #};

  libjpeg-turbo = mkGeoserverExtension {
    name = "libjpeg-turbo";
    version = "2.28.0"; # libjpeg-turbo
    hash = "sha256-d0YjP3rcz/IYSfWXqSDVuQoQcKmx9JHJQe4QfdzxcIg="; # libjpeg-turbo
    buildInputs = [ libjpeg.out ];
  };

  mapml = mkGeoserverExtension {
    name = "mapml";
    version = "2.28.0"; # mapml
    hash = "sha256-BhfiruT8vDuadf0v8elbfbP98VrV87iMViUoF1b1EbU="; # mapml
  };

  mbstyle = mkGeoserverExtension {
    name = "mbstyle";
    version = "2.28.0"; # mbstyle
    hash = "sha256-pt2anxfBmN1fECpERmV7dqLjDKHXmxQhA4XPTq1IEJs="; # mbstyle
  };

  metadata = mkGeoserverExtension {
    name = "metadata";
    version = "2.28.0"; # metadata
    hash = "sha256-v1X1l3Gid3o9pp46AM3rNJ8TxMnqy9dP15qxWIdwxG4="; # metadata
  };

  mongodb = mkGeoserverExtension {
    name = "mongodb";
    version = "2.28.0"; # mongodb
    hash = "sha256-BA1kLI2s40gSbdIQpBhiVl84/cUxmd3bm6aVl6Y+xFI="; # mongodb
  };

  monitor = mkGeoserverExtension {
    name = "monitor";
    version = "2.28.0"; # monitor
    hash = "sha256-aJlOySnHhTIA/JEbILBWU0/j5UkboK9F4K0RsMcWTbA="; # monitor
  };

  mysql = mkGeoserverExtension {
    name = "mysql";
    version = "2.28.0"; # mysql
    hash = "sha256-4m9kgyq6TWCk1M6kCqjoxdeoXV2eOYF68mm6yOevjK4="; # mysql
  };

  netcdf = mkGeoserverExtension {
    name = "netcdf";
    version = "2.28.0"; # netcdf
    hash = "sha256-Sx+LAUeC/rxTUJ+pD6FHdKtxbo/Rhkk9KxH4Yyh7X8Y="; # netcdf
    buildInputs = [ netcdf ];
  };

  netcdf-out = mkGeoserverExtension {
    name = "netcdf-out";
    version = "2.28.0"; # netcdf-out
    hash = "sha256-MHjgFpcLzI7rDoKABXoyzqUMk9ve3bTITd5qmV/mobo="; # netcdf-out
    buildInputs = [ netcdf ];
  };

  ogr-wfs = mkGeoserverExtension {
    name = "ogr-wfs";
    version = "2.28.0"; # ogr-wfs
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-XQ0L2CNuqN6QrxQYon4x9158rJKtaqLn1cVt7qqJeDM="; # ogr-wfs
  };

  # Needs ogr-wfs extension.
  ogr-wps = mkGeoserverExtension {
    name = "ogr-wps";
    version = "2.28.0"; # ogr-wps
    # buildInputs = [ pkgs.gdal ];
    hash = "sha256-KiXPyjlIS2NiOVyViWtb5eNwbichlK9Xnj739miY6u4="; # ogr-wps
  };

  oracle = mkGeoserverExtension {
    name = "oracle";
    version = "2.28.0"; # oracle
    hash = "sha256-wn3h+SjhY2P/yNp+cW5BOAmb9QBUyrtM6bOuvZemNiM="; # oracle
  };

  params-extractor = mkGeoserverExtension {
    name = "params-extractor";
    version = "2.28.0"; # params-extractor
    hash = "sha256-AaV7SEyRswFDlU1/3BUDOWxbkmZWmvOaF5p21wlfmHQ="; # params-extractor
  };

  printing = mkGeoserverExtension {
    name = "printing";
    version = "2.28.0"; # printing
    hash = "sha256-llLkGwU04aV1m6iPyk8B3tW281NBllmosi+ODdT9uAQ="; # printing
  };

  pyramid = mkGeoserverExtension {
    name = "pyramid";
    version = "2.28.0"; # pyramid
    hash = "sha256-uvFywhMpsYhjZ7gjJQfA8c7ASbqAAdnDfWdr1XM7vHc="; # pyramid
  };

  querylayer = mkGeoserverExtension {
    name = "querylayer";
    version = "2.28.0"; # querylayer
    hash = "sha256-tsLvbSJlNLjbKddiH9ghbbyr+Hh4rLh5GVEw7YiMDZY="; # querylayer
  };

  sldservice = mkGeoserverExtension {
    name = "sldservice";
    version = "2.28.0"; # sldservice
    hash = "sha256-nV4g85eRN7HTQQmErpHjihTkYJalAsE+bDI1oN4TWl0="; # sldservice
  };

  sqlserver = mkGeoserverExtension {
    name = "sqlserver";
    version = "2.28.0"; # sqlserver
    hash = "sha256-gpc8pgIzJVIj2tmyEqxMJlhWvxqp3TRpipdE6/mhgns="; # sqlserver
  };

  vectortiles = mkGeoserverExtension {
    name = "vectortiles";
    version = "2.28.0"; # vectortiles
    hash = "sha256-NvWB5W0ytPWkltaK3YUogbHgpzCMVC9+DDZ81SDOYW0="; # vectortiles
  };

  wcs2_0-eo = mkGeoserverExtension {
    name = "wcs2_0-eo";
    version = "2.28.0"; # wcs2_0-eo
    hash = "sha256-FnZUnT76HhC3m7Lv6PvFFPwwCZLpaATKRNf5VhposGw="; # wcs2_0-eo
  };

  web-resource = mkGeoserverExtension {
    name = "web-resource";
    version = "2.28.0"; # web-resource
    hash = "sha256-9L0J7yhK+DGCeVQY3nRZkgAigyAQnuJIapldNhM5Cec="; # web-resource
  };

  wmts-multi-dimensional = mkGeoserverExtension {
    name = "wmts-multi-dimensional";
    version = "2.28.0"; # wmts-multi-dimensional
    hash = "sha256-NBTneW1vy1+4N5lhLj/IH0Jn/+tiOtvek1g6zGgqjbE="; # wmts-multi-dimensional
  };

  wps = mkGeoserverExtension {
    name = "wps";
    version = "2.28.0"; # wps
    hash = "sha256-/9QMb5HlYSwMOSVlqmEM6y7D0pG2xkXpYtKhGrA5U0U="; # wps
  };

  # Needs hazelcast (https://github.com/hazelcast/hazelcast (?)) which is not
  # available in nixpgs as of 2024/01.
  #wps-cluster-hazelcast = mkGeoserverExtension {
  #  name = "wps-cluster-hazelcast";
  #  version = "2.28.0"; # wps-cluster-hazelcast
  #  hash = "sha256-uc5qUKuTI1SVRCU2uGBJ8jEkZTA18gCxQyZwW64xi5Y="; # wps-cluster-hazelcast
  #};

  wps-download = mkGeoserverExtension {
    name = "wps-download";
    version = "2.28.0"; # wps-download
    hash = "sha256-oI5w4CEQVUkHtuKSsLziyN+KvhFWcYJpmXUIvaMSmdQ="; # wps-download
  };

  # Needs Postrgres configuration or similar.
  # See https://docs.geoserver.org/main/en/user/extensions/wps-jdbc/index.html
  wps-jdbc = mkGeoserverExtension {
    name = "wps-jdbc";
    version = "2.28.0"; # wps-jdbc
    hash = "sha256-mmTHd23wJGQJ2vewgqiFxVXeTQskFEtLEmAe3tsYuZk="; # wps-jdbc
  };

  ysld = mkGeoserverExtension {
    name = "ysld";
    version = "2.28.0"; # ysld
    hash = "sha256-Nt12hH3erH6kHBM417h+adYSpPekFslWfLEGp7pl3kw="; # ysld
  };

}
