{
  lib,
  stdenv,
  fetchurl,
  home ? "/var/lib/crowd",
  port ? 8092,
  proxyUrl ? null,
  openidPassword ? "WILL_NEVER_BE_SET",
}:

lib.warnIf (openidPassword != "WILL_NEVER_BE_SET") "Using `crowdProperties` is deprecated!" (
  stdenv.mkDerivation rec {
    pname = "atlassian-crowd";
    version = "5.0.1";

    src = fetchurl {
      url = "https://www.atlassian.com/software/crowd/downloads/binary/${pname}-${version}.tar.gz";
      sha256 = "sha256-ccXSNuiXP0+b9WObboikqVd0nKH0Fi2gMVEF3+WAx5M=";
    };

    buildPhase =
      ''
        mv apache-tomcat/conf/server.xml apache-tomcat/conf/server.xml.dist
        ln -s /run/atlassian-crowd/server.xml apache-tomcat/conf/server.xml

        rm -rf apache-tomcat/{logs,work}
        ln -s /run/atlassian-crowd/logs apache-tomcat/logs
        ln -s /run/atlassian-crowd/work apache-tomcat/work

        ln -s /run/atlassian-crowd/database database

        substituteInPlace apache-tomcat/bin/startup.sh --replace start run

        echo "crowd.home=${home}" > crowd-webapp/WEB-INF/classes/crowd-init.properties
        substituteInPlace build.properties \
          --replace "openidserver.url=http://localhost:8095/openidserver" \
                    "openidserver.url=http://localhost:${toString port}/openidserver"
        substituteInPlace crowd-openidserver-webapp/WEB-INF/classes/crowd.properties \
          --replace "http://localhost:8095/" \
                    "http://localhost:${toString port}/"
        sed -r -i crowd-openidserver-webapp/WEB-INF/classes/crowd.properties \
          -e 's,application.password\s+password,application.password ${openidPassword},'
      ''
      + lib.optionalString (proxyUrl != null) ''
        sed -i crowd-openidserver-webapp/WEB-INF/classes/crowd.properties \
          -e 's,http://localhost:${toString port}/openidserver,${proxyUrl}/openidserver,'
      '';

    installPhase = ''
      cp -rva . $out
    '';

    meta = with lib; {
      description = "Single sign-on and identity management tool";
      homepage = "https://www.atlassian.com/software/crowd";
      license = licenses.unfree;
      maintainers = [ ];
    };
  }
)
