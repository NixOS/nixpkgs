{ config, pkgs, serverInfo, servicesPath, ... }:

let

  inherit (pkgs.lib) mkOption;

  urlPrefix = config.urlPrefix;
  dbDir = "${config.dataDir}/db";
  reposDir = "${config.dataDir}/repos";
  backupsDir = "${config.dataDir}/backup";
  distsDir = "${config.dataDir}/dist";
  tmpDir = "${config.dataDir}/tmp";
  logDir = "${config.dataDir}/log";
  idString = if config.id == "" then "" else "${config.id}-";
  postCommitHook = "/var/run/current-system/sw/bin/svn-server-${idString}post-commit-hook";
  fsType = "fsfs";
  adminAddr = serverInfo.adminAddr;
  


  # Build a Subversion instance with Apache modules and Swig/Python bindings.
  subversion = pkgs.subversion.override (origArgs: {
    bdbSupport = true;
    httpServer = true;
    sslSupport = true;
    compressionSupport = true;
    pythonBindings = true;
  });


  # Build the maintenance scripts and commit hooks.
  scripts = substituteInAll {
    name = "svn-server-scripts";
    src = /* pkgs.lib.cleanSource */ "${servicesPath}/subversion/src/scripts";

    # The variables to substitute:
    
    inherit reposDir dbDir logDir distsDir backupsDir tmpDir
      urlPrefix adminAddr fsType subversion postCommitHook mailer;
    inherit (config) notificationSender userCreationDomain;
    orgUrl = config.organisation.url;
    orgLogoUrl = config.organisation.logo;
    orgName = config.organisation.name;
      
    perl = "${pkgs.perl}/bin/perl";

    sendmail = "${pkgs.ssmtp}/sbin/sendmail";
    
    inherit (pkgs) libxslt enscript db4 coreutils diffutils bzip2 python;

    inherit (serverInfo) canonicalName;

    inherit (serverInfo.serverConfig) user group;    
    
    # Urgh, most of these are dependencies of Email::Send, should figure them out automatically.
    perlFlags = map (x: "-I${x}/lib/perl5/site_perl") [
      pkgs.perlPackages.BerkeleyDB pkgs.perlPackages.EmailSend
      pkgs.perlPackages.EmailSimple pkgs.perlPackages.ModulePluggable
      pkgs.perlPackages.ReturnValue pkgs.perlPackages.EmailAddress
      pkgs.perlPackages.CryptPasswordMD5
      pkgs.perlPackages.StringMkPasswd
    ];

    pythonPath = "${subversion}/lib/${pkgs.python.libPrefix}/site-packages";

    # Do a syntax check on the generated file.
    postInstall = ''
      $perl -c -T $out/cgi-bin/repoman.pl
      $perl -c $out/bin/svn-server-create-user.pl
      if test -n "${config.id}"; then
        for i in $(cd $out/bin && echo *); do
          mv "$out/bin/$i" "$out/bin/$(echo $i | sed s^svn-server-^svn-server-${config.id}-^)"
        done
      fi
    '';
  };


  # Extract the mailer script from the Subversion source distribution.
  mailer = pkgs.runCommand "svn-mailer.py" { inherit (subversion) src; }
    ''
      unpackFile $src
      cp subversion-*/tools/hook-scripts/mailer/mailer.py $out
    '';

  
  # Build our custom authentication modules.
  authModules = import "${servicesPath}/subversion/src/auth" {
    inherit (pkgs) stdenv apacheHttpd;
  };


  commonAuth = ''
    AuthType Basic
    AuthName "Subversion repositories"
    AuthBasicProvider dbm
    AuthDBMType DB
    AuthDBMUserFile ${dbDir}/svn-users
  '';
  

  # Access controls for /repos and /repos-xml. 
  reposConfig = dirName: ''
    ${commonAuth}

    AuthAllowNone on

    AuthzRepoPrefix ${urlPrefix}/${dirName}/
    AuthzRepoDBType DB
    AuthzRepoReaders ${dbDir}/svn-readers
    AuthzRepoWriters ${dbDir}/svn-writers

    <LimitExcept GET PROPFIND OPTIONS REPORT>
        Require repo-writer
    </LimitExcept>

    <Limit GET PROPFIND OPTIONS REPORT>
        Require repo-reader
    </Limit>

    DAV svn
    SVNParentPath ${reposDir}
    SVNAutoversioning ${if config.autoVersioning then "on" else "off"}
  '';


  # Build ViewVC.
  viewvc = import "${servicesPath}/subversion/src/viewvc" {
    inherit (pkgs) fetchurl stdenv python enscript;
    inherit urlPrefix reposDir adminAddr subversion;
  };


  viewerConfig = dirName: ''
    ${commonAuth}
    AuthAllowNone on
    AuthzRepoPrefix ${urlPrefix}/${dirName}/
    AuthzRepoDBType DB
    AuthzRepoReaders ${dbDir}/svn-readers
    Require repo-reader
  '';


  viewvcConfig = ''
    ScriptAlias ${urlPrefix}/viewvc ${viewvc}/viewvc/bin/mod_python/viewvc.py

    <Location ${urlPrefix}/viewvc>
        AddHandler python-program .py
        # Note: we write \" instead of ' to work around a lexer bug in Nix 0.11.
        PythonPath "[\"${viewvc}/viewvc/bin/mod_python\", \"${subversion}/lib/${pkgs.python.libPrefix}/site-packages\"] + sys.path"
        PythonHandler handler
        ${viewerConfig "viewvc"}
    </Location>

    Alias ${urlPrefix}/viewvc-doc ${viewvc}/viewvc/templates/docroot

    Redirect permanent ${urlPrefix}/viewcvs ${serverInfo.canonicalName}/${urlPrefix}/viewvc
  '';


  # Build WebSVN.
  websvn = import "${servicesPath}/subversion/src/websvn" {
    inherit (pkgs) fetchurl stdenv writeText enscript gnused diffutils;
    inherit urlPrefix reposDir subversion;
    cacheDir = tmpDir;
  };

  
  websvnConfig = ''
    Alias ${urlPrefix}/websvn ${websvn}/wsvn.php
    Alias ${urlPrefix}/templates ${websvn}/templates

    <Location ${urlPrefix}/websvn>
        ${viewerConfig "websvn"}
    </Location>

    <Directory ${websvn}/templates>
        Order allow,deny
        Allow from all
    </Directory>
  '';


  distConfig = ''
    Alias ${urlPrefix}/dist ${distsDir}

    <Directory "${distsDir}">
        AllowOverride None
        Options Indexes FollowSymLinks
        Order allow,deny
        Allow from all
        IndexOptions +SuppressDescription +NameWidth=*
        IndexIgnore *.rev *.lock
        IndexStyleSheet ${urlPrefix}/style.css
    </Directory>

    <Location ${urlPrefix}/dist>
        ${viewerConfig "dist"}
    </Location>
  '';
  

  repomanConfig = ''
    ScriptAlias ${urlPrefix}/repoman ${scripts}/cgi-bin/repoman.pl

    <Location ${urlPrefix}/repoman/listdetails>
        ${commonAuth}    
        Require valid-user
    </Location>

    <Location ${urlPrefix}/repoman/adduser>
        Order deny,allow
        Deny from all
        Allow from 127.0.0.1
        Allow from ${config.userCreationDomain}
    </Location>

    <Location ${urlPrefix}/repoman/edituser>
        ${commonAuth}    
        Require valid-user
    </Location>

    <Location ${urlPrefix}/repoman/create>
        ${commonAuth}    
        Require valid-user
        Order deny,allow
        Deny from all
        Allow from 127.0.0.1
        Allow from ${config.userCreationDomain}
    </Location>

    <Location ${urlPrefix}/repoman/update>
        ${commonAuth}    
        Require valid-user
    </Location>

    <Location ${urlPrefix}/repoman/dump>
        ${viewerConfig "repoman/dump"}
    </Location>
  '';


  staticFiles = substituteInSome {
    name = "svn-static-files";
    src = /* pkgs.lib.cleanSource */ "${servicesPath}/subversion/root";
    files = ["xsl/svnindex.xsl"];
    inherit urlPrefix;
  };

  staticFilesConfig = ''
    Alias ${urlPrefix}/svn-files ${staticFiles}/
    <Directory ${staticFiles}>
        Order allow,deny
        Allow from all
    </Directory>
  '';

  
  # !!! should be in Nixpkgs.
  substituteInSome = args: pkgs.stdenv.mkDerivation ({
    buildCommand = ''
      ensureDir $out
      cp -prd $src/* $out
      chmod -R u+w $out
      for i in $files; do
        args=
        substituteAll $out/$i $out/$i
      done
    '';
  } // args); # */
    
  substituteInAll = args: pkgs.stdenv.mkDerivation ({
    buildCommand = ''
      ensureDir $out
      cp -prd $src/* $out
      chmod -R u+w $out
      find $out -type f -print | while read fn; do
        args=
        substituteAll $fn $fn
      done
      eval "$postInstall"
    '';
  } // args); # */

      
in {

  extraModulesPre = [
    # Allow anonymous access to repositories that are world-readable
    # without prompting for a username/password.
    { name = "authn_noauth"; path = "${authModules}/modules/mod_authn_noauth.so"; }
    # Check whether the user is allowed read or write access to a
    # repository.
    { name = "authz_dyn";    path = "${authModules}/modules/mod_authz_dyn.so"; }
  ];

  extraModules = [
    { name = "python";  path = "${pkgs.mod_python}/modules/mod_python.so"; }
    { name = "php5";    path = "${pkgs.php}/modules/libphp5.so"; }
    { name = "dav_svn"; path = "${subversion}/modules/mod_dav_svn.so"; }
  ];

  
  extraConfig = ''
  
    <Location ${urlPrefix}/repos>
      ${reposConfig "repos"}
    </Location>
    
    <Location ${urlPrefix}/repos-xml>
      ${reposConfig "repos-xml"}
      SVNIndexXSLT "${urlPrefix}/svn-files/xsl/svnindex.xsl"
    </Location>

    ${viewvcConfig}

    ${websvnConfig}

    ${repomanConfig}

    ${distConfig}

    ${staticFilesConfig}

    ${if config.toplevelRedirect then ''
        <Location ${urlPrefix}/>
            DirectoryIndex repoman
        </Location>
      '' else ""}
        
  '';

  
  robotsEntries = ''
    User-agent: *
    Disallow: ${urlPrefix}/viewcvs/
    Disallow: ${urlPrefix}/viewvc/
    Disallow: ${urlPrefix}/websvn/
    Disallow: ${urlPrefix}/repos-xml/
  '';

  
  # mod_python's own Python modules must be in the initial Python
  # path, they cannot be set through the PythonPath directive.
  globalEnvVars = [
    { name = "PYTHONPATH"; value = "${pkgs.mod_python}/lib/${pkgs.python.libPrefix}/site-packages"; }
  ];

  
  extraServerPath = [
    # Needed for ViewVC.
    "${pkgs.diffutils}/bin"
    "${pkgs.gnused}/bin"
  ];

  
  extraPath = [scripts];


  startupScript = "${scripts}/bin/svn-server-${idString}startup-hook.sh";
  

  options = {

    id = mkOption {
      default = "";
      example = "test";
      description = "
        A unique identifier necessary to keep multiple Subversion server
        instances on the same machine apart.  This is used to
        disambiguate the administrative scripts, which get names like
        svn-server-<id>-delete-repo.pl.  In particular it keeps
        the post-commit hooks of different instances apart.
      ";
    };

    urlPrefix = mkOption {
      default = "/subversion";
      description = "
        The URL prefix under which the Subversion service appears.
        Use the empty string to have it appear in the server root.
      ";
    };

    toplevelRedirect = mkOption {
      default = true;
      description = "
        Whether <varname>urlPrefix</varname> without any suffix
        (except a slash) should redirect to
        <varname>urlPrefix</varname><literal>/repoman</literal>.
      ";
    };

    notificationSender = mkOption {
      default = "svn-server@example.org";
      example = "svn-server@example.org";
      description = "
        The email address used in the Sender field of commit
        notification messages sent by the Subversion subservice.
      ";
    };

    userCreationDomain = mkOption {
      default = "example.org"; 
      example = "example.org";
      description = "
        The domain from which user creation is allowed.  A client can
        only create a new user account if its IP address resolves to
        this domain.
      ";
    };

    autoVersioning = mkOption {
      default = false;
      description = "
        Whether you want the Subversion subservice to support
        auto-versioning, which enables Subversion repositories to be
        mounted as read/writable file systems on operating systems that
        support WebDAV.
      ";
    };

    dataDir = mkOption {
      example = "/data/subversion";
      description = "
        Path to the directory that holds the repositories, user database, etc.
      ";
    };

    organisation = {

      name = mkOption {
        default = null;
        description = "
          Name of the organization hosting the Subversion service.
        ";
      };

      url = mkOption {
        default = null;
        description = "
          URL of the website of the organization hosting the Subversion service.
        ";
      };

      logo = mkOption {
        default = null;
        description = "
          Logo the organization hosting the Subversion service.
        ";
      };

    };

  };
  
}
