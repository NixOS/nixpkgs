{ config, pkgs, serverInfo, ... }:

let
  inherit (pkgs.lib) mkOption;
  
  # Build a Subversion instance with Apache modules and Swig/Python bindings.
  subversion = pkgs.subversion.override (origArgs: {
    bdbSupport = true;
    httpServer = true;
    sslSupport = true;
    compressionSupport = true;
    pythonBindings = true;
  });
in
{
  options = {
    projectsLocation = mkOption {
      description = "URL path in which Trac projects can be accessed";
      default = "/projects";
    };
  };

  extraModules = [
    { name = "python"; path = "${pkgs.mod_python}/modules/mod_python.so"; }
  ];
  
  extraConfig = ''
      <Location ${config.projectsLocation}>
        SetHandler mod_python
        PythonHandler trac.web.modpython_frontend
	PythonOption TracEnvParentDir /var/trac/projects
        PythonOption TracUriRoot ${config.projectsLocation}
        PythonOption PYTHON_EGG_CACHE /var/trac/egg-cache
      </Location>
  '';
  
  globalEnvVars = [
    { name = "PYTHONPATH";
      value = 
        "${pkgs.mod_python}/lib/python2.5/site-packages:" +
	"${pkgs.pythonPackages.trac}/lib/python2.5/site-packages:" +
	"${pkgs.setuptools}/lib/python2.5/site-packages:" +
	"${pkgs.pythonPackages.genshi}/lib/python2.5/site-packages:" +
	"${pkgs.pythonPackages.psycopg2}/lib/python2.5/site-packages:" +
	"${subversion}/lib/python2.5/site-packages";
    }
  ];
}
