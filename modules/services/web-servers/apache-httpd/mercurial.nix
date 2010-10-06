{ config, pkgs, serverInfo, servicesPath, ... }:

let
  inherit (pkgs) mercurial;
  inherit (pkgs.lib) mkOption;

  urlPrefix = config.urlPrefix;
  
  cgi = pkgs.stdenv.mkDerivation {
    name = "mercurial-cgi";  
    buildCommand = ''
      ensureDir $out
      cp -v ${mercurial}/share/cgi-bin/hgweb.cgi $out
      sed -i "s|/path/to/repo/or/config|$out/hgweb.config|" $out/hgweb.cgi
      echo "
      [collections]
      ${config.dataDir} = ${config.dataDir}
      [web]
      style = gitweb
      allow_push = *
      " > $out/hgweb.config
    '';
  };
      
in {

  extraConfig = ''
    RewriteEngine on
    RewriteRule /(.*) ${cgi}/hgweb.cgi/$1

    <Location "${urlPrefix}">
        AuthType Basic
        AuthName "Mercurial repositories"
        AuthUserFile ${config.dataDir}/hgusers
        <LimitExcept GET>
            Require valid-user
        </LimitExcept>
    </Location>
    <Directory "${cgi}">
        Order allow,deny
        Allow from all
        AllowOverride All
        Options ExecCGI
        AddHandler cgi-script .cgi
        SetEnv PYTHONPATH "${mercurial}/lib/${pkgs.python.libPrefix}/site-packages"
        PassEnv PYTHONPATH
    </Directory>
  '';
  
  robotsEntries = ''
    User-agent: *
    Disallow: ${urlPrefix}
  '';
  
  extraServerPath = [
    (pkgs.python+"/bin")    
  ];
  
  options = {
    urlPrefix = mkOption {
      default = "/hg";
      description = "
        The URL prefix under which the Mercurial service appears.
        Use the empty string to have it appear in the server root.
      ";
    };
    
    dataDir = mkOption {
      example = "/data/mercurial";
      description = "
        Path to the directory that holds the repositories.
      ";
    };
  };
  
}
