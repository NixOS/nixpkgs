{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.gitit;

  homeDir = "/var/lib/gitit";

  toYesNo = b: if b then "yes" else "no";

  gititShared = with cfg.haskellPackages; gitit + "/share/" + ghc.targetPrefix + ghc.haskellCompilerName + "/" + gitit.pname + "-" + gitit.version;

  gititWithPkgs = hsPkgs: extras: hsPkgs.ghcWithPackages (self: with self; [ gitit ] ++ (extras self));

  gititSh = hsPkgs: extras: with pkgs; let
    env = gititWithPkgs hsPkgs extras;
  in writeScript "gitit" ''
    #!${runtimeShell}
    cd $HOME
    export NIX_GHC="${env}/bin/ghc"
    export NIX_GHCPKG="${env}/bin/ghc-pkg"
    export NIX_GHC_DOCDIR="${env}/share/doc/ghc/html"
    export NIX_GHC_LIBDIR=$( $NIX_GHC --print-libdir )
    ${env}/bin/gitit -f ${configFile}
  '';

  gititOptions = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Enable the gitit service.";
      };

      haskellPackages = mkOption {
        default = pkgs.haskellPackages;
        defaultText = literalExpression "pkgs.haskellPackages";
        example = literalExpression "pkgs.haskell.packages.ghc784";
        description = lib.mdDoc "haskellPackages used to build gitit and plugins.";
      };

      extraPackages = mkOption {
        type = types.functionTo (types.listOf types.package);
        default = self: [];
        example = literalExpression ''
          haskellPackages: [
            haskellPackages.wreq
          ]
        '';
        description = ''
          Extra packages available to ghc when running gitit. The
          value must be a function which receives the attrset defined
          in <varname>haskellPackages</varname> as the sole argument.
        '';
      };

      address = mkOption {
        type = types.str;
        default = "0.0.0.0";
        description = lib.mdDoc "IP address on which the web server will listen.";
      };

      port = mkOption {
        type = types.int;
        default = 5001;
        description = lib.mdDoc "Port on which the web server will run.";
      };

      wikiTitle = mkOption {
        type = types.str;
        default = "Gitit!";
        description = lib.mdDoc "The wiki title.";
      };

      repositoryType = mkOption {
        type = types.enum ["git" "darcs" "mercurial"];
        default = "git";
        description = lib.mdDoc "Specifies the type of repository used for wiki content.";
      };

      repositoryPath = mkOption {
        type = types.path;
        default = homeDir + "/wiki";
        description = lib.mdDoc ''
          Specifies the path of the repository directory. If it does not
          exist, gitit will create it on startup.
        '';
      };

      requireAuthentication = mkOption {
        type = types.enum [ "none" "modify" "read" ];
        default = "modify";
        description = lib.mdDoc ''
          If 'none', login is never required, and pages can be edited
          anonymously.  If 'modify', login is required to modify the wiki
          (edit, add, delete pages, upload files).  If 'read', login is
          required to see any wiki pages.
        '';
      };

      authenticationMethod = mkOption {
        type = types.enum [ "form" "http" "generic" "github" ];
        default = "form";
        description = lib.mdDoc ''
          'form' means that users will be logged in and registered using forms
          in the gitit web interface.  'http' means that gitit will assume that
          HTTP authentication is in place and take the logged in username from
          the "Authorization" field of the HTTP request header (in addition,
          the login/logout and registration links will be suppressed).
          'generic' means that gitit will assume that some form of
          authentication is in place that directly sets REMOTE_USER to the name
          of the authenticated user (e.g. mod_auth_cas on apache).  'rpx' means
          that gitit will attempt to log in through https://rpxnow.com.  This
          requires that 'rpx-domain', 'rpx-key', and 'base-url' be set below,
          and that 'curl' be in the system path.
        '';
      };

      userFile = mkOption {
        type = types.path;
        default = homeDir + "/gitit-users";
        description = lib.mdDoc ''
          Specifies the path of the file containing user login information.  If
          it does not exist, gitit will create it (with an empty user list).
          This file is not used if 'http' is selected for
          authentication-method.
        '';
      };

      sessionTimeout = mkOption {
        type = types.int;
        default = 60;
        description = lib.mdDoc ''
          Number of minutes of inactivity before a session expires.
        '';
      };

      staticDir = mkOption {
        type = types.path;
        default = gititShared + "/data/static";
        description = lib.mdDoc ''
          Specifies the path of the static directory (containing javascript,
          css, and images).  If it does not exist, gitit will create it and
          populate it with required scripts, stylesheets, and images.
        '';
      };

      defaultPageType = mkOption {
        type = types.enum [ "markdown" "rst" "latex" "html" "markdown+lhs" "rst+lhs" "latex+lhs" ];
        default = "markdown";
        description = lib.mdDoc ''
          Specifies the type of markup used to interpret pages in the wiki.
          Possible values are markdown, rst, latex, html, markdown+lhs,
          rst+lhs, and latex+lhs. (the +lhs variants treat the input as
          literate Haskell. See pandoc's documentation for more details.) If
          Markdown is selected, pandoc's syntax extensions (for footnotes,
          delimited code blocks, etc.) will be enabled. Note that pandoc's
          restructuredtext parser is not complete, so some pages may not be
          rendered correctly if rst is selected. The same goes for latex and
          html.
        '';
      };

      math = mkOption {
        type = types.enum [ "mathml" "raw" "mathjax" "jsmath" "google" ];
        default = "mathml";
        description = lib.mdDoc ''
          Specifies how LaTeX math is to be displayed.  Possible values are
          mathml, raw, mathjax, jsmath, and google.  If mathml is selected,
          gitit will convert LaTeX math to MathML and link in a script,
          MathMLinHTML.js, that allows the MathML to be seen in Gecko browsers,
          IE + mathplayer, and Opera. In other browsers you may get a jumble of
          characters.  If raw is selected, the LaTeX math will be displayed as
          raw LaTeX math.  If mathjax is selected, gitit will link to the
          remote mathjax script.  If jsMath is selected, gitit will link to the
          script /js/jsMath/easy/load.js, and will assume that jsMath has been
          installed into the js/jsMath directory.  This is the most portable
          solution. If google is selected, the google chart API is called to
          render the formula as an image. This requires a connection to google,
          and might raise a technical or a privacy problem.
        '';
      };

      mathJaxScript = mkOption {
        type = types.str;
        default = "https://d3eoax9i5htok0.cloudfront.net/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML";
        description = lib.mdDoc ''
          Specifies the path to MathJax rendering script.  You might want to
          use your own MathJax script to render formulas without Internet
          connection or if you want to use some special LaTeX packages.  Note:
          path specified there cannot be an absolute path to a script on your
          hdd, instead you should run your (local if you wish) HTTP server
          which will serve the MathJax.js script. You can easily (in four lines
          of code) serve MathJax.js using
          http://happstack.com/docs/crashcourse/FileServing.html Do not forget
          the "http://" prefix (e.g. http://localhost:1234/MathJax.js).
        '';
      };

      showLhsBirdTracks = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Specifies whether to show Haskell code blocks in "bird style", with
          "> " at the beginning of each line.
        '';
      };

      templatesDir = mkOption {
        type = types.path;
        default = gititShared + "/data/templates";
        description = ''
          Specifies the path of the directory containing page templates.  If it
          does not exist, gitit will create it with default templates.  Users
          may wish to edit the templates to customize the appearance of their
          wiki. The template files are HStringTemplate templates.  Variables to
          be interpolated appear between $\'s. Literal $\'s must be
          backslash-escaped.
        '';
      };

      logFile = mkOption {
        type = types.path;
        default = homeDir + "/gitit.log";
        description = lib.mdDoc ''
          Specifies the path of gitit's log file.  If it does not exist, gitit
          will create it. The log is in Apache combined log format.
        '';
      };

      logLevel = mkOption {
        type = types.enum [ "DEBUG" "INFO" "NOTICE" "WARNING" "ERROR" "CRITICAL" "ALERT" "EMERGENCY" ];
        default = "ERROR";
        description = lib.mdDoc ''
          Determines how much information is logged.  Possible values (from
          most to least verbose) are DEBUG, INFO, NOTICE, WARNING, ERROR,
          CRITICAL, ALERT, EMERGENCY.
        '';
      };

      frontPage = mkOption {
        type = types.str;
        default = "Front Page";
        description = lib.mdDoc ''
          Specifies which wiki page is to be used as the wiki's front page.
          Gitit creates a default front page on startup, if one does not exist
          already.
        '';
      };

      noDelete = mkOption {
        type = types.str;
        default = "Front Page, Help";
        description = lib.mdDoc ''
          Specifies pages that cannot be deleted through the web interface.
          (They can still be deleted directly using git or darcs.) A
          comma-separated list of page names.  Leave blank to allow every page
          to be deleted.
        '';
      };

      noEdit = mkOption {
        type = types.str;
        default = "Help";
        description = lib.mdDoc ''
          Specifies pages that cannot be edited through the web interface.
          Leave blank to allow every page to be edited.
        '';
      };

      defaultSummary = mkOption {
        type = types.str;
        default = "";
        description = lib.mdDoc ''
          Specifies text to be used in the change description if the author
          leaves the "description" field blank.  If default-summary is blank
          (the default), the author will be required to fill in the description
          field.
        '';
      };

      tableOfContents = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Specifies whether to print a tables of contents (with links to
          sections) on each wiki page.
        '';
      };

      plugins = mkOption {
        type = with types; listOf str;
        default = [ (gititShared + "/plugins/Dot.hs") ];
        description = lib.mdDoc ''
          Specifies a list of plugins to load. Plugins may be specified either
          by their path or by their module name. If the plugin name starts
          with Gitit.Plugin., gitit will assume that the plugin is an installed
          module and will not try to find a source file.
        '';
      };

      useCache = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Specifies whether to cache rendered pages.  Note that if use-feed is
          selected, feeds will be cached regardless of the value of use-cache.
        '';
      };

      cacheDir = mkOption {
        type = types.path;
        default = homeDir + "/cache";
        description = lib.mdDoc "Path where rendered pages will be cached.";
      };

      maxUploadSize = mkOption {
        type = types.str;
        default = "1000K";
        description = lib.mdDoc ''
          Specifies an upper limit on the size (in bytes) of files uploaded
          through the wiki's web interface.  To disable uploads, set this to
          0K.  This will result in the uploads link disappearing and the
          _upload url becoming inactive.
        '';
      };

      maxPageSize = mkOption {
        type = types.str;
        default = "1000K";
        description = lib.mdDoc "Specifies an upper limit on the size (in bytes) of pages.";
      };

      debugMode = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Causes debug information to be logged while gitit is running.";
      };

      compressResponses = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc "Specifies whether HTTP responses should be compressed.";
      };

      mimeTypesFile = mkOption {
        type = types.path;
        default = "/etc/mime/types.info";
        description = ''
          Specifies the path of a file containing mime type mappings.  Each
          line of the file should contain two fields, separated by whitespace.
          The first field is the mime type, the second is a file extension.
          For example:
<programlisting>
video/x-ms-wmx  wmx
</programlisting>
          If the file is not found, some simple defaults will be used.
        '';
      };

      useReCaptcha = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          If true, causes gitit to use the reCAPTCHA service
          (http://recaptcha.net) to prevent bots from creating accounts.
        '';
      };

      reCaptchaPrivateKey = mkOption {
        type = with types; nullOr str;
        default = null;
        description = lib.mdDoc ''
          Specifies the private key for the reCAPTCHA service.  To get
          these, you need to create an account at http://recaptcha.net.
        '';
      };

      reCaptchaPublicKey = mkOption {
        type = with types; nullOr str;
        default = null;
        description = lib.mdDoc ''
          Specifies the public key for the reCAPTCHA service.  To get
          these, you need to create an account at http://recaptcha.net.
        '';
      };

      accessQuestion = mkOption {
        type = types.str;
        default = "What is the code given to you by Ms. X?";
        description = lib.mdDoc ''
          Specifies a question that users must answer when they attempt to
          create an account
        '';
      };

      accessQuestionAnswers = mkOption {
        type = types.str;
        default = "RED DOG, red dog";
        description = lib.mdDoc ''
          Specifies a question that users must answer when they attempt to
          create an account, along with a comma-separated list of acceptable
          answers.  This can be used to institute a rudimentary password for
          signing up as a user on the wiki, or as an alternative to reCAPTCHA.
          Example:
          access-question:  What is the code given to you by Ms. X?
          access-question-answers:  RED DOG, red dog
        '';
      };

      rpxDomain = mkOption {
        type = with types; nullOr str;
        default = null;
        description = lib.mdDoc ''
          Specifies the domain and key of your RPX account.  The domain is just
          the prefix of the complete RPX domain, so if your full domain is
          'https://foo.rpxnow.com/', use 'foo' as the value of rpx-domain.
        '';
      };

      rpxKey = mkOption {
        type = with types; nullOr str;
        default = null;
        description = lib.mdDoc "RPX account access key.";
      };

      mailCommand = mkOption {
        type = types.str;
        default = "sendmail %s";
        description = lib.mdDoc ''
          Specifies the command to use to send notification emails.  '%s' will
          be replaced by the destination email address.  The body of the
          message will be read from stdin.  If this field is left blank,
          password reset will not be offered.
        '';
      };

      resetPasswordMessage = mkOption {
        type = types.lines;
        default = ''
          > From: gitit@$hostname$
          > To: $useremail$
          > Subject: Wiki password reset
          >
          > Hello $username$,
          >
          > To reset your password, please follow the link below:
          > http://$hostname$:$port$$resetlink$
          >
          > Regards
        '';
        description = lib.mdDoc ''
          Gives the text of the message that will be sent to the user should
          she want to reset her password, or change other registration info.
          The lines must be indented, and must begin with '>'.  The initial
          spaces and '> ' will be stripped off.  $username$ will be replaced by
          the user's username, $useremail$ by her email address, $hostname$ by
          the hostname on which the wiki is running (as returned by the
          hostname system call), $port$ by the port on which the wiki is
          running, and $resetlink$ by the relative path of a reset link derived
          from the user's existing hashed password. If your gitit wiki is being
          proxied to a location other than the root path of $port$, you should
          change the link to reflect this: for example, to
          http://$hostname$/path/to/wiki$resetlink$ or
          http://gitit.$hostname$$resetlink$
        '';
      };

      useFeed = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Specifies whether an ATOM feed should be enabled (for the site and
          for individual pages).
        '';
      };

      baseUrl = mkOption {
        type = with types; nullOr str;
        default = null;
        description = lib.mdDoc ''
          The base URL of the wiki, to be used in constructing feed IDs and RPX
          token_urls.  Set this if useFeed is false or authentication-method
          is 'rpx'.
        '';
      };

      absoluteUrls = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Make wikilinks absolute with respect to the base-url.  So, for
          example, in a wiki served at the base URL '/wiki', on a page
          Sub/Page, the wikilink '[Cactus]()' will produce a link to
          '/wiki/Cactus' if absoluteUrls is true, and a relative link to
          'Cactus' (referring to '/wiki/Sub/Cactus') if absolute-urls is 'no'.
        '';
      };

      feedDays = mkOption {
        type = types.int;
        default = 14;
        description = lib.mdDoc "Number of days to be included in feeds.";
      };

      feedRefreshTime = mkOption {
        type = types.int;
        default = 60;
        description = lib.mdDoc "Number of minutes to cache feeds before refreshing.";
      };

      pdfExport = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          If true, PDF will appear in export options. PDF will be created using
          pdflatex, which must be installed and in the path. Note that PDF
          exports create significant additional server load.
        '';
      };

      pandocUserData = mkOption {
        type = with types; nullOr path;
        default = null;
        description = lib.mdDoc ''
          If a directory is specified, this will be searched for pandoc
          customizations. These can include a templates/ directory for custom
          templates for various export formats, an S5 directory for custom S5
          styles, and a reference.odt for ODT exports. If no directory is
          specified, $HOME/.pandoc will be searched. See pandoc's README for
          more information.
        '';
      };

      xssSanitize = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          If true, all HTML (including that produced by pandoc) is filtered
          through xss-sanitize.  Set to no only if you trust all of your users.
        '';
      };

      oauthClientId = mkOption {
        type = with types; nullOr str;
        default = null;
        description = lib.mdDoc "OAuth client ID";
      };

      oauthClientSecret = mkOption {
        type = with types; nullOr str;
        default = null;
        description = lib.mdDoc "OAuth client secret";
      };

      oauthCallback = mkOption {
        type = with types; nullOr str;
        default = null;
        description = lib.mdDoc "OAuth callback URL";
      };

      oauthAuthorizeEndpoint = mkOption {
        type = with types; nullOr str;
        default = null;
        description = lib.mdDoc "OAuth authorize endpoint";
      };

      oauthAccessTokenEndpoint = mkOption {
        type = with types; nullOr str;
        default = null;
        description = lib.mdDoc "OAuth access token endpoint";
      };

      githubOrg = mkOption {
        type = with types; nullOr str;
        default = null;
        description = lib.mdDoc "Github organization";
      };
  };

  configFile = pkgs.writeText "gitit.conf" ''
    address: ${cfg.address}
    port: ${toString cfg.port}
    wiki-title: ${cfg.wikiTitle}
    repository-type: ${cfg.repositoryType}
    repository-path: ${cfg.repositoryPath}
    require-authentication: ${cfg.requireAuthentication}
    authentication-method: ${cfg.authenticationMethod}
    user-file: ${cfg.userFile}
    session-timeout: ${toString cfg.sessionTimeout}
    static-dir: ${cfg.staticDir}
    default-page-type: ${cfg.defaultPageType}
    math: ${cfg.math}
    mathjax-script: ${cfg.mathJaxScript}
    show-lhs-bird-tracks: ${toYesNo cfg.showLhsBirdTracks}
    templates-dir: ${cfg.templatesDir}
    log-file: ${cfg.logFile}
    log-level: ${cfg.logLevel}
    front-page: ${cfg.frontPage}
    no-delete: ${cfg.noDelete}
    no-edit: ${cfg.noEdit}
    default-summary: ${cfg.defaultSummary}
    table-of-contents: ${toYesNo cfg.tableOfContents}
    plugins: ${concatStringsSep "," cfg.plugins}
    use-cache: ${toYesNo cfg.useCache}
    cache-dir: ${cfg.cacheDir}
    max-upload-size: ${cfg.maxUploadSize}
    max-page-size: ${cfg.maxPageSize}
    debug-mode: ${toYesNo cfg.debugMode}
    compress-responses: ${toYesNo cfg.compressResponses}
    mime-types-file: ${cfg.mimeTypesFile}
    use-recaptcha: ${toYesNo cfg.useReCaptcha}
    recaptcha-private-key: ${toString cfg.reCaptchaPrivateKey}
    recaptcha-public-key: ${toString cfg.reCaptchaPublicKey}
    access-question: ${cfg.accessQuestion}
    access-question-answers: ${cfg.accessQuestionAnswers}
    rpx-domain: ${toString cfg.rpxDomain}
    rpx-key: ${toString cfg.rpxKey}
    mail-command: ${cfg.mailCommand}
    reset-password-message: ${cfg.resetPasswordMessage}
    use-feed: ${toYesNo cfg.useFeed}
    base-url: ${toString cfg.baseUrl}
    absolute-urls: ${toYesNo cfg.absoluteUrls}
    feed-days: ${toString cfg.feedDays}
    feed-refresh-time: ${toString cfg.feedRefreshTime}
    pdf-export: ${toYesNo cfg.pdfExport}
    pandoc-user-data: ${toString cfg.pandocUserData}
    xss-sanitize: ${toYesNo cfg.xssSanitize}

    [Github]
    oauthclientid: ${toString cfg.oauthClientId}
    oauthclientsecret: ${toString cfg.oauthClientSecret}
    oauthcallback: ${toString cfg.oauthCallback}
    oauthauthorizeendpoint: ${toString cfg.oauthAuthorizeEndpoint}
    oauthaccesstokenendpoint: ${toString cfg.oauthAccessTokenEndpoint}
    github-org: ${toString cfg.githubOrg}
  '';

in

{

  options.services.gitit = gititOptions;

  config = mkIf cfg.enable {

    users.users.gitit = {
      group = config.users.groups.gitit.name;
      description = "Gitit user";
      home = homeDir;
      createHome = true;
      uid = config.ids.uids.gitit;
    };

    users.groups.gitit.gid = config.ids.gids.gitit;

    systemd.services.gitit = let
      uid = toString config.ids.uids.gitit;
      gid = toString config.ids.gids.gitit;
    in {
      description = "Git and Pandoc Powered Wiki";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [ curl ]
             ++ optional cfg.pdfExport texlive.combined.scheme-basic
             ++ optional (cfg.repositoryType == "darcs") darcs
             ++ optional (cfg.repositoryType == "mercurial") mercurial
             ++ optional (cfg.repositoryType == "git") git;

      preStart = let
        gm = "gitit@${config.networking.hostName}";
      in
      with cfg; ''
        chown ${uid}:${gid} -R ${homeDir}
        for dir in ${repositoryPath} ${staticDir} ${templatesDir} ${cacheDir}
        do
          if [ ! -d $dir ]
          then
            mkdir -p $dir
            find $dir -type d -exec chmod 0750 {} +
            find $dir -type f -exec chmod 0640 {} +
          fi
        done
        cd ${repositoryPath}
        ${
          if repositoryType == "darcs" then
          ''
          if [ ! -d _darcs ]
          then
            darcs initialize
            echo "${gm}" > _darcs/prefs/email
          ''
          else if repositoryType == "mercurial" then
          ''
          if [ ! -d .hg ]
          then
            hg init
            cat >> .hg/hgrc <<NAMED
[ui]
username = gitit ${gm}
NAMED
          ''
          else
          ''
          if [ ! -d  .git ]
          then
            git init
            git config user.email "${gm}"
            git config user.name "gitit"
          ''}
          chown ${uid}:${gid} -R ${repositoryPath}
          fi
        cd -
      '';

      serviceConfig = {
        User = config.users.users.gitit.name;
        Group = config.users.groups.gitit.name;
        ExecStart = with cfg; gititSh haskellPackages extraPackages;
      };
    };
  };
}
