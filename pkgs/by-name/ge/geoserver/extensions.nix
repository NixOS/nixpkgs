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
    version = "3.0.2"; # app-schema
    hash = "sha256-xZJ6dipcYKgUrq3OUyl9zN2y2SfknRp1boEHa1SUas4="; # app-schema
  };

  arcgrid = mkGeoserverExtension {
    name = "arcgrid";
    version = "3.0.2"; # arcgrid
    hash = "sha256-DyKNuGSRjvIJyBRIuUtRlEPY6MoWG3dG0OAE2rr9ciw="; # arcgrid
  };

  authkey = mkGeoserverExtension {
    name = "authkey";
    version = "3.0.2"; # authkey
    hash = "sha256-tPdu9EJ0hQ+3b6skxInb3RIobSfVvAFO5v29FFYCYr0="; # authkey
  };

  cas = mkGeoserverExtension {
    name = "cas";
    version = "3.0.2"; # cas
    hash = "sha256-5/8trRVm1lrUGKnOXBuxu9EVTcwWMdwnaQEO+bYQXpQ="; # cas
  };

  charts = mkGeoserverExtension {
    name = "charts";
    version = "3.0.2"; # charts
    hash = "sha256-mhs7cGX8+ZwGmCRaGOiCMnZW3saw8fKKMngL7mhVdHE="; # charts
  };

  control-flow = mkGeoserverExtension {
    name = "control-flow";
    version = "3.0.2"; # control-flow
    hash = "sha256-QZ5vmh+3oivzIVIGYG95syLuMQqImcaf9Ic3vyd23qk="; # control-flow
  };

  css = mkGeoserverExtension {
    name = "css";
    version = "3.0.2"; # css
    hash = "sha256-32TJBC8+1mSo4O+RKv/l3uwn+3TsqJsklZ7ZIUy2uvM="; # css
  };

  csw = mkGeoserverExtension {
    name = "csw";
    version = "3.0.2"; # csw
    hash = "sha256-dxUXsWlWFNbLd5b7Ytr0TxDWBPQoJMH6sAV7PUs/X0Q="; # csw
  };

  csw-iso = mkGeoserverExtension {
    name = "csw-iso";
    version = "3.0.2"; # csw-iso
    hash = "sha256-2NHMLaoSkRIdZaKzbNfSOtyFAmqrgcljofaKPmAxazU="; # csw-iso
  };

  db2 = mkGeoserverExtension {
    name = "db2";
    version = "3.0.2"; # db2
    hash = "sha256-zYP1QGJpTRWBcLdO2nrHEJlwe9RSSUlULzDc/Z468fI="; # db2
  };

  # Needs wps extension.
  dxf = mkGeoserverExtension {
    name = "dxf";
    version = "3.0.2"; # dxf
    hash = "sha256-s+45MxpxIdTz27+72M/T/I9rInAMs+qAZGTiliwDCt0="; # dxf
  };

  excel = mkGeoserverExtension {
    name = "excel";
    version = "3.0.2"; # excel
    hash = "sha256-eJH/wT2/D4d5nPoDHe0MyF4Rw9sl066jCbw199EGXn8="; # excel
  };

  feature-pregeneralized = mkGeoserverExtension {
    name = "feature-pregeneralized";
    version = "3.0.2"; # feature-pregeneralized
    hash = "sha256-N0dBR6EsdNo+7D+evgmoHfsiITOGBlwGpSvZd7yHa8M="; # feature-pregeneralized
  };

  # Note: The extension name ("gdal") clashes with pkgs.gdal.
  gdal = mkGeoserverExtension {
    name = "gdal";
    version = "3.0.2"; # gdal
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-aCt/aa4hqV6JaQY5A9h7ES+QIsnBIf+8BaUBD85sRGo="; # gdal
  };

  geopkg-output = mkGeoserverExtension {
    name = "geopkg-output";
    version = "3.0.2"; # geopkg-output
    hash = "sha256-v4qMchOHqhu9J6Q3MRvdZK1WMFbvP0E0mSj28CJkspY="; # geopkg-output
  };

  grib = mkGeoserverExtension {
    name = "grib";
    version = "3.0.2"; # grib
    hash = "sha256-DOnypqF2rcSv8c6Mf8fr1zzecLkj1JMuH959ZFTlnqM="; # grib
    buildInputs = [ netcdf ];
  };

  gwc-s3 = mkGeoserverExtension {
    name = "gwc-s3";
    version = "3.0.2"; # gwc-s3
    hash = "sha256-FOfn+pl34EOf3TKYTalZV6hDEMXpwTFzSEm4RaN3anA="; # gwc-s3
  };

  iau = mkGeoserverExtension {
    name = "iau";
    version = "3.0.2"; # iau
    hash = "sha256-48lhqhoH5CimYLHqRfXD/llBUycPkKaxY5WAxLctr9Y="; # iau
  };

  image = mkGeoserverExtension {
    name = "image";
    version = "3.0.2"; # image
    hash = "sha256-s+XU0480uvAodofyFOr50hbi+AJsCaZ/5plQgasXinI="; # image
  };

  importer = mkGeoserverExtension {
    name = "importer";
    version = "3.0.2"; # importer
    hash = "sha256-lTrpdIfu3q+OsCesQdAB9kAPCByG4wgmJvM79tTW3kE="; # importer
  };

  inspire = mkGeoserverExtension {
    name = "inspire";
    version = "3.0.2"; # inspire
    hash = "sha256-R7/KTCOUZzEw9DFjjGTR+wSczhPC72FJQ2nB5OqRNAI="; # inspire
  };

  # only sun jp2k is supported at the moment, not kakadu
  # see https://docs.geoserver.org/main/en/user/extensions/jp2k/
  jp2k = mkGeoserverExtension {
    name = "jp2k";
    version = "3.0.2"; # jp2k
    hash = "sha256-b5zPUyUnG9rMbszx/SIr48wvdYlbUBBK5WHBIQC2ftc="; # jp2k
  };

  kml = mkGeoserverExtension {
    name = "kml";
    version = "3.0.2"; # inspire
    hash = "sha256-VzUdQ6xMr2KTiUADCDHJHnLrYUTWRGZTAuwr4ti5dkI="; # kml
  };

  # Throws "java.lang.UnsatisfiedLinkError: 'void org.libjpegturbo.turbojpeg.TJDecompressor.init()'"
  # as of 2.28.1.
  # As of 3.0.0, loads correctly, but logs show:
  # WARN   [turbojpeg.TurboJPEGMapResponse] - The turbo jpeg encoder is not available, check the native libs installation
  # NOTE: When re-enabling this, RE-ENABLE THE CORRESPONDING TEST, TOO! (See tests/geoserver.nix)
  #libjpeg-turbo = mkGeoserverExtension {
  #  name = "libjpeg-turbo";
  #  version = "3.0.2"; # libjpeg-turbo
  #  hash = "sha256-h8VtlHt2zRw5+Jpxc0NtjqWqMmkC4yCUkprJaowy6N0="; # libjpeg-turbo
  #  buildInputs = [ libjpeg ];
  #};

  mapml = mkGeoserverExtension {
    name = "mapml";
    version = "3.0.2"; # mapml
    hash = "sha256-J/gc4upF6c4n67NyNYFd28cT24g1vDiDV0ZpRFoB138="; # mapml
  };

  mbstyle = mkGeoserverExtension {
    name = "mbstyle";
    version = "3.0.2"; # mbstyle
    hash = "sha256-xCJCUMCveu/6gVI4AVAabJNpRwbKrLp1cgOYox3jJrA="; # mbstyle
  };

  metadata = mkGeoserverExtension {
    name = "metadata";
    version = "3.0.2"; # metadata
    hash = "sha256-DKzlrFsLeRtgwIWrfV7ulvOfSBBkp62bWFtkedSnq2Q="; # metadata
  };

  mongodb = mkGeoserverExtension {
    name = "mongodb";
    version = "3.0.2"; # mongodb
    hash = "sha256-MuDhL+Zi6bkZlvwI1hgf/x8qF03CgiH31XhtdYdm6Qc="; # mongodb
  };

  monitor = mkGeoserverExtension {
    name = "monitor";
    version = "3.0.2"; # monitor
    hash = "sha256-tZKolt7RDvzsH5VdfTImxZaMjGi04rForlEkchSl5uU="; # monitor
  };

  mysql = mkGeoserverExtension {
    name = "mysql";
    version = "3.0.2"; # mysql
    hash = "sha256-R28ToJ9TRsuIChpsOlhil5p4QurAnW2CfkN5j9CghZo="; # mysql
  };

  netcdf = mkGeoserverExtension {
    name = "netcdf";
    version = "3.0.2"; # netcdf
    hash = "sha256-hadTZ1MYs2vxTaqfMrmiW3rwdLV147BI1HL5Xu6c1TA="; # netcdf
    buildInputs = [ netcdf ];
  };

  netcdf-out = mkGeoserverExtension {
    name = "netcdf-out";
    version = "3.0.2"; # netcdf-out
    hash = "sha256-j3lRL+pY6jApnSCSGwYv5PhKNpus3LR97j1Ok7I75QU="; # netcdf-out
    buildInputs = [ netcdf ];
  };

  ogcapi-features = mkGeoserverExtension {
    name = "ogcapi-features";
    version = "3.0.2"; # ogcapi-features
    # buildInputs = [ pkgs.gdal ];
    hash = "sha256-Zpood8rF001NMDLM0dGjIMv1BO32iyWF1CDNWzLztQg="; # ogcapi-features
  };

  ogr-wfs = mkGeoserverExtension {
    name = "ogr-wfs";
    version = "3.0.2"; # ogr-wfs
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-9BxMNbMugZ1+ZG6f+8WDjEr/yRsTqD6KDhMtRD3v7Zw="; # ogr-wfs
  };

  # Needs ogr-wfs extension.
  ogr-wps = mkGeoserverExtension {
    name = "ogr-wps";
    version = "3.0.2"; # ogr-wps
    # buildInputs = [ pkgs.gdal ];
    hash = "sha256-DH7uDB+UBonIbinqE7ymk7FOYsxmid8PrT4JE08JtlQ="; # ogr-wps
  };

  oracle = mkGeoserverExtension {
    name = "oracle";
    version = "3.0.2"; # oracle
    hash = "sha256-pt+odTgmcBcf73YldUgHoQjVnI7ECgvxAVyIJ2Jv7kY="; # oracle
  };

  params-extractor = mkGeoserverExtension {
    name = "params-extractor";
    version = "3.0.2"; # params-extractor
    hash = "sha256-eLGeiIuwKLnXpApqaRkY3bWsbhPIAVzPFaRk4gwDFGc="; # params-extractor
  };

  printing = mkGeoserverExtension {
    name = "printing";
    version = "3.0.2"; # printing
    hash = "sha256-UBfXGPdJKj4dHNQf3eAGp3vOfTrdDvKISjuL0aXM++c="; # printing
  };

  pyramid = mkGeoserverExtension {
    name = "pyramid";
    version = "3.0.2"; # pyramid
    hash = "sha256-0oiWNdWhh+6wfpib2fz7ueSP9RL70SEDeCCOFVCCB2E="; # pyramid
  };

  querylayer = mkGeoserverExtension {
    name = "querylayer";
    version = "3.0.2"; # querylayer
    hash = "sha256-4TBjRU0OooBJAplnru8ZjYAFkDQCViiqW8/gdrJSmaI="; # querylayer
  };

  rat = mkGeoserverExtension {
    name = "rat";
    version = "3.0.2"; # sldservice
    hash = "sha256-LL9Pprcy45qlyHWOga+xjR480DiJHOkaYnjpCIea7IE="; # sldservice
  };

  sec-oidc = mkGeoserverExtension {
    name = "sec-oidc";
    version = "3.0.2"; # sldservice
    hash = "sha256-jWrqoYNfIR3UsYYiBeGG8P74evZUzc0Nrh3KdX/UDNo="; # sec-oidc
  };

  sldservice = mkGeoserverExtension {
    name = "sldservice";
    version = "3.0.2"; # sldservice
    hash = "sha256-LL9Pprcy45qlyHWOga+xjR480DiJHOkaYnjpCIea7IE="; # sldservice
  };

  sqlserver = mkGeoserverExtension {
    name = "sqlserver";
    version = "3.0.2"; # sqlserver
    hash = "sha256-IkK1CbQVJ6RvB4XqeAW/ACWFzSUaHmsPZIwnM2ReczY="; # sqlserver
  };

  vectortiles = mkGeoserverExtension {
    name = "vectortiles";
    version = "3.0.2"; # vectortiles
    hash = "sha256-sgTPm7VTsXpUbjJpTGnAp4dvsfb3KVtOlEeIFqar3xk="; # vectortiles
  };

  wcs1_0 = mkGeoserverExtension {
    name = "wcs1_0";
    version = "3.0.2"; # wcs1_0
    hash = "sha256-UXAdBvNXd6v8WCrjRhx/gTgNUO5rBf1ddScFbWEwZzg="; # wcs1_0
  };

  wcs1_1 = mkGeoserverExtension {
    name = "wcs1_1";
    version = "3.0.2"; # wcs1_1
    hash = "sha256-2ax6PbW9nZRhPsqd12VfuKNxDRVo4GzPAIUpsXHpW94="; # wcs1_1
  };

  wcs2_0-eo = mkGeoserverExtension {
    name = "wcs2_0-eo";
    version = "3.0.2"; # wcs2_0-eo
    hash = "sha256-JU4buH+Xr4SLRC1F+Ma730Ue0WwFzHtagjoedQIfRwQ="; # wcs2_0-eo
  };

  web-resource = mkGeoserverExtension {
    name = "web-resource";
    version = "3.0.2"; # web-resource
    hash = "sha256-DOMYvJo8Xa+0GEZEEqD9oEIrx++W3qg1taIGPA5NQcU="; # web-resource
  };

  wmts-multi-dimensional = mkGeoserverExtension {
    name = "wmts-multi-dimensional";
    version = "3.0.2"; # wmts-multi-dimensional
    hash = "sha256-YMJdz/4WojGWOmjSFv+gkwdEsNpXMMnpFlVxz09G/1A="; # wmts-multi-dimensional
  };

  wps = mkGeoserverExtension {
    name = "wps";
    version = "3.0.2"; # wps
    hash = "sha256-IsYU0sR1lhTBq14lKwCBQy7tJXHx9F3CulegdlKQGF8="; # wps
  };

  # Needs hazelcast (https://github.com/hazelcast/hazelcast (?)) which is not
  # available in nixpgs as of 2024/01.
  #wps-cluster-hazelcast = mkGeoserverExtension {
  #  name = "wps-cluster-hazelcast";
  #  version = "3.0.2"; # wps-cluster-hazelcast
  #  hash = "sha256-aP2GVera1gGzVO6lzdXz0+M+AxSM4W46n6gJgNH2Mp8="; # wps-cluster-hazelcast
  #};

  wps-download = mkGeoserverExtension {
    name = "wps-download";
    version = "3.0.2"; # wps-download
    hash = "sha256-jnk+wbhwEouk9a1G4sC1+ve976aA8b23WCWoDiERc/w="; # wps-download
  };

  wps-excel = mkGeoserverExtension {
    name = "wps-excel";
    version = "3.0.2"; # wps-excel
    hash = "sha256-pnUFg5FHy24pGys9nRH/gfMAUW0JFaxvrJ5hwFvAZh0="; # wps-excel
  };

  # Needs Postrgres configuration or similar.
  # See https://docs.geoserver.org/main/en/user/extensions/wps-jdbc/index.html
  wps-jdbc = mkGeoserverExtension {
    name = "wps-jdbc";
    version = "3.0.2"; # wps-jdbc
    hash = "sha256-M27FOPFfN7NUTaTOFI6NjLkgyDinPSysLbRk2JegD6Q="; # wps-jdbc
  };

  ysld = mkGeoserverExtension {
    name = "ysld";
    version = "3.0.2"; # ysld
    hash = "sha256-xoTQrpHeEA3k0s0tTEabux2fOL5KF9J/ywPTaDYR0Fw="; # ysld
  };

}
