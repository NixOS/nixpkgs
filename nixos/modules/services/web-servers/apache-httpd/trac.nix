{ config, lib, pkgs, serverInfo, ... }:

with lib;

let

  # Build a Subversion instance with Apache modules and Swig/Python bindings.
  subversion = pkgs.subversion.override {
    bdbSupport = true;
    httpServer = true;
    pythonBindings = true;
    apacheHttpd = httpd;
  };

  pythonLib = p: "${p}/";

  httpd = serverInfo.serverConfig.package;

  versionPre24 = versionOlder httpd.version "2.4";

in

{

  options = {

    projectsLocation = mkOption {
      description = "URL path in which Trac projects can be accessed";
      default = "/projects";
    };

    projects = mkOption {
      description = "List of projects that should be provided by Trac. If they are not defined yet empty projects are created.";
      default = [];
      example =
        [ { identifier = "myproject";
            name = "My Project";
            databaseURL="postgres://root:password@/tracdb";
            subversionRepository="/data/subversion/myproject";
          }
        ];
    };

    user = mkOption {
      default = "wwwrun";
      description = "User account under which Trac runs.";
    };

    group = mkOption {
      default = "wwwrun";
      description = "Group under which Trac runs.";
    };

    ldapAuthentication = {
      enable = mkOption {
        default = false;
        description = "Enable the ldap authentication in trac";
      };

      url = mkOption {
        default = "ldap://127.0.0.1/dc=example,dc=co,dc=ke?uid?sub?(objectClass=inetOrgPerson)";
        description = "URL of the LDAP authentication";
      };

      name = mkOption {
        default = "Trac server";
        description = "AuthName";
      };
    };

  };

  extraModules = singleton
    { name = "python"; path = "${pkgs.mod_python}/modules/mod_python.so"; };

  extraConfig = ''
    <Location ${config.projectsLocation}>
      SetHandler mod_python
      PythonHandler trac.web.modpython_frontend
      PythonOption TracEnvParentDir /var/trac/projects
      PythonOption TracUriRoot ${config.projectsLocation}
      PythonOption PYTHON_EGG_CACHE /var/trac/egg-cache
    </Location>
    ${if config.ldapAuthentication.enable then ''
      <LocationMatch "^${config.projectsLocation}[^/]+/login$">
        AuthType Basic
        AuthName "${config.ldapAuthentication.name}"
        AuthBasicProvider "ldap"
        AuthLDAPURL "${config.ldapAuthentication.url}"
        ${if versionPre24 then "authzldapauthoritative Off" else ""}
        require valid-user
      </LocationMatch>
    '' else ""}
  '';

  globalEnvVars = singleton
    { name = "PYTHONPATH";
      value =
        makeSearchPath "lib/${pkgs.python.libPrefix}/site-packages"
          [ pkgs.mod_python
            pkgs.pythonPackages.trac
            pkgs.setuptools
            pkgs.pythonPackages.genshi
            pkgs.pythonPackages.psycopg2
            pkgs.python.modules.sqlite3
            subversion
          ];
    };

  startupScript = pkgs.writeScript "activateTrac" ''
    mkdir -p /var/trac
    chown ${config.user}:${config.group} /var/trac

    ${concatMapStrings (project:
      ''
        if [ ! -d /var/trac/${project.identifier} ]
        then
            export PYTHONPATH=${pkgs.pythonPackages.psycopg2}/lib/${pkgs.python.libPrefix}/site-packages
            ${pkgs.pythonPackages.trac}/bin/trac-admin /var/trac/${project.identifier} initenv "${project.name}" "${project.databaseURL}" svn "${project.subversionRepository}"
        fi
      '' ) (config.projects)}
  '';

}
