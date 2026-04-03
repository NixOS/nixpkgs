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
    version = "2.28.2"; # app-schema
    hash = "sha256-wJ0grTy8ZeiifvINLgbuLXdDYQeQvXKkGcFoYxlkOjI="; # app-schema
  };

  authkey = mkGeoserverExtension {
    name = "authkey";
    version = "2.28.2"; # authkey
    hash = "sha256-vy9HLjt1Lefd1+2QlKPHKU9IcPYfDPWcfqzInFahBBk="; # authkey
  };

  cas = mkGeoserverExtension {
    name = "cas";
    version = "2.28.2"; # cas
    hash = "sha256-Z3FdAdVHrzNPiA1L/9cnSr/7QsevlqhxBoSwOfjap/E="; # cas
  };

  charts = mkGeoserverExtension {
    name = "charts";
    version = "2.28.2"; # charts
    hash = "sha256-ZLFI6taLpSw9uIsAr8zAsP0xIHqKHhlnffCglEhmvbU="; # charts
  };

  control-flow = mkGeoserverExtension {
    name = "control-flow";
    version = "2.28.2"; # control-flow
    hash = "sha256-ncKjBkYJGqtgsSU2RCMkfZd4jnqWCxaVf3VfQTHHv7Q="; # control-flow
  };

  css = mkGeoserverExtension {
    name = "css";
    version = "2.28.2"; # css
    hash = "sha256-TAvS6VoJEkxUHaz/5/Sng2f8tvTWUZVeriL8uOrtb0I="; # css
  };

  csw = mkGeoserverExtension {
    name = "csw";
    version = "2.28.2"; # csw
    hash = "sha256-AR229hydrY1D5rxpGFfyDAPgsceDcs46nH/vyHyn484="; # csw
  };

  csw-iso = mkGeoserverExtension {
    name = "csw-iso";
    version = "2.28.2"; # csw-iso
    hash = "sha256-7s+Eu+Ik+9+C3+LMZ6gZowVLg8kuNOY9ZlsZEUDKRDg="; # csw-iso
  };

  db2 = mkGeoserverExtension {
    name = "db2";
    version = "2.28.2"; # db2
    hash = "sha256-ipjFaGsVfBebKjMS9r7ZNHanNdbSA2lcdsLufr/ohgI="; # db2
  };

  # Needs wps extension.
  dxf = mkGeoserverExtension {
    name = "dxf";
    version = "2.28.2"; # dxf
    hash = "sha256-H7dugiW/fldMWVCqr3aPAYgYQUkBFutBALeOmYJouhE="; # dxf
  };

  excel = mkGeoserverExtension {
    name = "excel";
    version = "2.28.2"; # excel
    hash = "sha256-wWxOVpy41sAQMqHgR+B8zIdQV05VIi7gV0on1rrqZ0g="; # excel
  };

  feature-pregeneralized = mkGeoserverExtension {
    name = "feature-pregeneralized";
    version = "2.28.2"; # feature-pregeneralized
    hash = "sha256-f6tqDnW3AI/Kg3Dd4w9CdoqhJoygN4EiNjht1mH3o3s="; # feature-pregeneralized
  };

  # Note: The extension name ("gdal") clashes with pkgs.gdal.
  gdal = mkGeoserverExtension {
    name = "gdal";
    version = "2.28.2"; # gdal
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-jT3QhjrQiTtZHCCyBE1F7MfEanNRdzjdRQ/Ao+Azars="; # gdal
  };

  # Throws "java.io.FileNotFoundException: URL [jar:file:/nix/store/.../WEB-INF/lib/gs-geofence-server-2.24.1.jar!/geofence-default-override.properties] cannot be resolved to absolute file path because it does not reside in the file system: jar:file:/nix/store/.../WEB-INF/lib/gs-geofence-server-2.24.1.jar!/geofence-default-override.properties" but seems to work out of the box.
  #geofence = mkGeoserverExtension {
  #  name = "geofence";
  #  version = "2.28.2"; # geofence
  #  hash = "sha256-G72N5BRMIlkyfldeHdwNHM4kKEhbhp52VkJKaObtPQI="; # geofence
  #};

  #geofence-server-h2 = mkGeoserverExtension {
  #  name = "geofence-server-h2";
  #  version = "2.28.2"; # geofence-server
  #  hash = "sha256-qgm2jNXGYJ40lFmWN/ksWf6GxzLTYhZwkIRr0/dvItc="; # geofence-server-h2
  #};

  #geofence-server-postgres = mkGeoserverExtension {
  #  name = "geofence-server-postgres";
  #  version = "2.28.2"; # geofence-server
  #  hash = "sha256-3vkf+jIdmt/ZMci1PSeA7yVoUuo5d5vuuowQ1G7pz6M="; # geofence-server-postgres
  #};

  #geofence-wps = mkGeoserverExtension {
  #  name = "geofence-wps";
  #  version = "2.28.2"; # geofence-wps
  #  hash = "sha256-Bl+0gte7buh4uMbK6AEJOs3HHCZ1s6sED7UrB1v69BM="; # geofence-wps
  #};

  geopkg-output = mkGeoserverExtension {
    name = "geopkg-output";
    version = "2.28.2"; # geopkg-output
    hash = "sha256-ccf6PP7lSnkPCguewaTkLiszmeNB1KRlc6sku1aUp3k="; # geopkg-output
  };

  grib = mkGeoserverExtension {
    name = "grib";
    version = "2.28.2"; # grib
    hash = "sha256-5QQhxLA6LR9ahEhLJM3FhFr7T30vzbXZ72sv2IbQuwA="; # grib
    buildInputs = [ netcdf ];
  };

  gwc-s3 = mkGeoserverExtension {
    name = "gwc-s3";
    version = "2.28.2"; # gwc-s3
    hash = "sha256-ZKo10/k5aY6SNVKNPs4U9x9rMaz/P6nqPt1PJHr7U1Y="; # gwc-s3
  };

  h2 = mkGeoserverExtension {
    name = "h2";
    version = "2.28.2"; # h2
    hash = "sha256-vkjZn5y0taVG13/1/RJuFoKIFcHx+Ju2yYYLV3K8Qdc="; # h2
  };

  iau = mkGeoserverExtension {
    name = "iau";
    version = "2.28.2"; # iau
    hash = "sha256-yIpXjMCYjWE/xMGuNg3iNDyjMVdQCvRBeNCBOS0c1JA="; # iau
  };

  importer = mkGeoserverExtension {
    name = "importer";
    version = "2.28.2"; # importer
    hash = "sha256-Kb02ihQ9WIjcXRS1Yc9gO968/YK/FRlQ2CQGZCZmy20="; # importer
  };

  inspire = mkGeoserverExtension {
    name = "inspire";
    version = "2.28.2"; # inspire
    hash = "sha256-fU0/4VvTlIhyjPTNIYIVdT8dygWG8r0qk45O1q4fr3U="; # inspire
  };

  # Needs Kakadu plugin from
  # https://github.com/geosolutions-it/imageio-ext
  #jp2k = mkGeoserverExtension {
  #  name = "jp2k";
  #  version = "2.28.2"; # jp2k
  #  hash = "sha256-eOg9w9z3KykTLvouWrUH4fvAJ1OaQJG7M9vA+3pwyFM="; # jp2k
  #};

  # Throws "java.lang.UnsatisfiedLinkError: 'void org.libjpegturbo.turbojpeg.TJDecompressor.init()'"
  # as of 2.28.1.
  # NOTE: When re-enabling this, RE-ENABLE THE CORRESPONDING TEST, TOO! (See tests/geoserver.nix)
  #libjpeg-turbo = mkGeoserverExtension {
  #  name = "libjpeg-turbo";
  #  version = "2.28.2"; # libjpeg-turbo
  #  hash = "sha256-4RQzkMXuOdQKszmafTWG5PekU8nCGVb7/Oumql8vqFc="; # libjpeg-turbo
  #  buildInputs = [ libjpeg.out ];
  #};

  mapml = mkGeoserverExtension {
    name = "mapml";
    version = "2.28.2"; # mapml
    hash = "sha256-qOYI6MT+Ihpa+aSbC77J96aaA2cSaPBei0ppsPhC0ks="; # mapml
  };

  mbstyle = mkGeoserverExtension {
    name = "mbstyle";
    version = "2.28.2"; # mbstyle
    hash = "sha256-M9Eg8DbiWTFrpZ26v7MdeKcxS+CscNTT/r7CPqGe7RI="; # mbstyle
  };

  metadata = mkGeoserverExtension {
    name = "metadata";
    version = "2.28.2"; # metadata
    hash = "sha256-EHtbBQpiqd56FtfizasbQtbMkwasOtZOcaRqStkjViU="; # metadata
  };

  mongodb = mkGeoserverExtension {
    name = "mongodb";
    version = "2.28.2"; # mongodb
    hash = "sha256-GlAXb1yx8bTAZr0z1H/3n6nODAsUeV21UgEej/97F4k="; # mongodb
  };

  monitor = mkGeoserverExtension {
    name = "monitor";
    version = "2.28.2"; # monitor
    hash = "sha256-zyCNr+Z/juYjD5cvcFssIe/fS/MxB8ZYaZsEOoPSBhI="; # monitor
  };

  mysql = mkGeoserverExtension {
    name = "mysql";
    version = "2.28.2"; # mysql
    hash = "sha256-xQPSia3O/K9wC9wQHiwle6Z1jXEgEUIWp59u4lVv2RU="; # mysql
  };

  netcdf = mkGeoserverExtension {
    name = "netcdf";
    version = "2.28.2"; # netcdf
    hash = "sha256-EXtbuSu0uBQ77BjKWTt6lw15Vb3X48MX7iF35JD8Z2s="; # netcdf
    buildInputs = [ netcdf ];
  };

  netcdf-out = mkGeoserverExtension {
    name = "netcdf-out";
    version = "2.28.2"; # netcdf-out
    hash = "sha256-I7Snzevhl/hTxriKULartxda3ZX7pXP0HxFEwJMHFZE="; # netcdf-out
    buildInputs = [ netcdf ];
  };

  ogr-wfs = mkGeoserverExtension {
    name = "ogr-wfs";
    version = "2.28.2"; # ogr-wfs
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-/8EebpM9Ppc2BqsOTEly6i/U358X9mCAkC5PE3z3Uw0="; # ogr-wfs
  };

  # Needs ogr-wfs extension.
  ogr-wps = mkGeoserverExtension {
    name = "ogr-wps";
    version = "2.28.2"; # ogr-wps
    # buildInputs = [ pkgs.gdal ];
    hash = "sha256-VTj2XBWXY+I73ux6Y/XTsAtvPpMXiuz+cieTmkNLr6M="; # ogr-wps
  };

  oracle = mkGeoserverExtension {
    name = "oracle";
    version = "2.28.2"; # oracle
    hash = "sha256-a6idJZfCy2iSB5UWOepeZ1YGlhrOaMNpxHkJ5+8bJGc="; # oracle
  };

  params-extractor = mkGeoserverExtension {
    name = "params-extractor";
    version = "2.28.2"; # params-extractor
    hash = "sha256-EEX0E3f4Y0A120Trz5molTFOIrcZVXXIdW3skn5ID7Y="; # params-extractor
  };

  printing = mkGeoserverExtension {
    name = "printing";
    version = "2.28.2"; # printing
    hash = "sha256-uyhqI14sy1refOaZwJZ81IEobrOiKIGKR1y80llNAv0="; # printing
  };

  pyramid = mkGeoserverExtension {
    name = "pyramid";
    version = "2.28.2"; # pyramid
    hash = "sha256-fHNbhIUBL9A4ND6QVT1Z1jPgqM0jz/MRt+WHmHIl2g4="; # pyramid
  };

  querylayer = mkGeoserverExtension {
    name = "querylayer";
    version = "2.28.2"; # querylayer
    hash = "sha256-tQ/BSL12Zj1hYAl582p+kYz+7SS5HGLvKOrA5c/hUXA="; # querylayer
  };

  sldservice = mkGeoserverExtension {
    name = "sldservice";
    version = "2.28.2"; # sldservice
    hash = "sha256-tKow9r+0km/IyzlubSi7NwfyuCm8jYIBv3PYkmcDGN0="; # sldservice
  };

  sqlserver = mkGeoserverExtension {
    name = "sqlserver";
    version = "2.28.2"; # sqlserver
    hash = "sha256-6J7tEPUXqtKcD0aKgHQv7/24Lpv4pOZZnWvmkNHTeco="; # sqlserver
  };

  vectortiles = mkGeoserverExtension {
    name = "vectortiles";
    version = "2.28.2"; # vectortiles
    hash = "sha256-MlP+mjoQZHc9SRPIfMcV7OtUFXM8Z9T+O+Ti6rWLQuc="; # vectortiles
  };

  wcs2_0-eo = mkGeoserverExtension {
    name = "wcs2_0-eo";
    version = "2.28.2"; # wcs2_0-eo
    hash = "sha256-xxClO61LYNX80npRHoYvNvzz/eeVZ7yHoA2uhqGNLyQ="; # wcs2_0-eo
  };

  web-resource = mkGeoserverExtension {
    name = "web-resource";
    version = "2.28.2"; # web-resource
    hash = "sha256-hPS8B3DF+Em0ffL+z5z39dzyHlcdW0bgNNU3rRfzA9c="; # web-resource
  };

  wmts-multi-dimensional = mkGeoserverExtension {
    name = "wmts-multi-dimensional";
    version = "2.28.2"; # wmts-multi-dimensional
    hash = "sha256-9wsLHgj0g+qGTfeVTkECfwIO1YwBRsxnS5H1NmsDqU0="; # wmts-multi-dimensional
  };

  wps = mkGeoserverExtension {
    name = "wps";
    version = "2.28.2"; # wps
    hash = "sha256-DaL2b26sHW7a3WVB19H/S6pEJDde8fRwrHBDitWXqDI="; # wps
  };

  # Needs hazelcast (https://github.com/hazelcast/hazelcast (?)) which is not
  # available in nixpgs as of 2024/01.
  #wps-cluster-hazelcast = mkGeoserverExtension {
  #  name = "wps-cluster-hazelcast";
  #  version = "2.28.2"; # wps-cluster-hazelcast
  #  hash = "sha256-+kgpkg+ZSi2IuupMUZ5O7aVXkeydylYv9ogALf4tDEM="; # wps-cluster-hazelcast
  #};

  wps-download = mkGeoserverExtension {
    name = "wps-download";
    version = "2.28.2"; # wps-download
    hash = "sha256-o3Ya6ez/Y0ia6dstYlkMd8t6UOc5dvfPo12BzsMpDh0="; # wps-download
  };

  # Needs Postrgres configuration or similar.
  # See https://docs.geoserver.org/main/en/user/extensions/wps-jdbc/index.html
  wps-jdbc = mkGeoserverExtension {
    name = "wps-jdbc";
    version = "2.28.2"; # wps-jdbc
    hash = "sha256-9Toz6BKX6XN4ohEX8+jEJ1z7aEYxbdFCiUmbiWYLXk8="; # wps-jdbc
  };

  ysld = mkGeoserverExtension {
    name = "ysld";
    version = "2.28.2"; # ysld
    hash = "sha256-XIQ6ksnySRNwtfMI696E57tIv1Aa2XKmyEpHdX7sRGs="; # ysld
  };

}
