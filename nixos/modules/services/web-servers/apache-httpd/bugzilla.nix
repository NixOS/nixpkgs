{ config, pkgs, serverInfo, lib, ... }:

with lib;

let
    httpd = serverInfo.serverConfig.package;

    checksetupConfig = ''
        \$answer{'ADMIN_LOGIN'} = '${config.adminLogin}';
        \$answer{'ADMIN_EMAIL'} = '${config.adminEmail}';
        \$answer{'ADMIN_PASSWORD'} = '${config.adminPass}';
        \$answer{'ADMIN_REALNAME'} = '${config.adminRealname}';

        \$answer{'SMTP_SERVER'} = '${config.smtpServer}';

        \$answer{'NO_PAUSE'} = 1
    '';

    bugzillaRoot = pkgs.stdenv.mkDerivation rec {
                    name = "bugzilla-5.1.1";

                    src = pkgs.fetchurl {
                        url = "https://ftp.mozilla.org/pub/webtools/${name}.tar.gz";
                        sha256 = "2d18aec033e33222ef70f2ae6e17ffd59240bd4c322e2c29e88f8759eb9a343b";
                    };

                    propagatedBuildInputs = with pkgs.perlPackages; [ perl DateTime TimeDate Chart
                                                       EmailMIME EmailSender GD GDGraph GDText SOAPLite
                                                       NetLDAP TemplateToolkit MathRandomISAAC
                                                       PatchReader TemplateGD DBI FileSlurp CGI PatchReader
                                                       JSONXS AuthenRadius NetLDAP EncodeDetect FileCopyRecursive
                                                       FileWhich HTMLScrubber EmailReply HTMLFormatTextWithLinks
                                                       TextMarkdown CacheMemcachedFast MIMETools XMLTwig
                                                       AuthenSASL NetSMTPSSL LWPProtocolHttps ApacheSizeLimit mod_perl2
                                                       (if config.dbType == "Pg" then [ DBDPg pkgs.postgresql96 ] else null)
                                                       FileMimeInfo
                    ];

                    # FIXME, how do you get settings from environment?
                    configurePhase = ''
                        perl checksetup.pl
                        substituteInPlace localconfig\
                            --replace "$db_driver = 'sqlite'" "$db_driver = '${config.dbType}'"\
                            --replace "$db_host = 'localhost'" "$db_host = '${config.dbServer}'"\
                            --replace "$db_name = 'bugs'" "$db_name = '${config.dbName}'"\
                            --replace "$db_user = 'bugs'" "$db_user = '${config.dbUser}'"\
                            --replace "$db_pass = \'\'" "$db_pass = '${config.dbPassword}';"\
                            --replace "$db_port = 0" "$db_port = ${config.dbPort}"
                        psql -U root -d postgres -c "
                            DO \$\$
                            BEGIN
                                IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = '${config.dbUser}') THEN
                                    CREATE USER ${config.dbUser} with PASSWORD '${config.dbPassword}';
                                END IF;
                                IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_database WHERE datname = '${config.dbName}') THEN
                                    CREATE DATABASE OWNER ${config.dbUser} ${config.dbName};
                                END IF;
                            END \$\$"

                        export PGPASSWORD="${config.dbPassword}"
                        echo "${checksetupConfig}"  > checksetup_config.pl
                        perl checksetup.pl checksetup_config.pl
                    '';

                    installPhase = ''
                      find . -type d -name CVS -exec rm -rf {} \; || true
                      find . -type f -name .cvsignore -exec rm -f {} \; || true
                      rm -rf .bzr
                      rm -rf .bzrrev
                      rm -rf .bzrignore
                      rm -rf .git
                      rm -rf .gitignore

                      cp -a ../${name} $out
                      echo PassEnv PERL5LIB >> .htaccess
                    '';
    };
in
{

    extraConfig = ''
        PerlSwitches -w -T
        PerlConfigRequire ${bugzillaRoot}/mod_perl.pl
   '';
    enablePerl = true;
    documentRoot = bugzillaRoot;

    options = {
        enable = mkOption {
            type = types.bool;
            default = false;
            description = "Enable bugzilla service";
        };

        # FIXME: use apache one
        adminEmail = mkOption {
            type = types.str;
            default = "foo@bar.com";
            description = "Admin email";
        };

        adminLogin = mkOption {
            type = types.str;
            default = "admin";
            description = "Admin login";
        };

        smtpServer = mkOption {
            type = types.str;
            default = "localhost";
            description = "SMTP server address";
        };

        adminPass = mkOption {
            type = types.str;
            default = "someLongPassword";
            description = "Admin password";
        };

        adminRealname = mkOption {
            type = types.str;
            default = "";
            description = "Admin real name";
        };

        dbType = mkOption {
            type = types.enum [ "Pg" ];
            default = "Pg";
            example = "mysql";
            description = "Database type";
        };

        dbServer = mkOption {
            type = types.str;
            default = "localhost"; # use a Unix domain socket
            example = "10.0.2.2";
            description = ''
              The location of the database server.  Leave empty to use a
              database server running on the same machine through a Unix
              domain socket.
            '';
        };

        dbName = mkOption {
            type = types.string;
            default = "bugs";
            description = "Database name";
        };

        dbPort = mkOption {
            type = types.str;
            default = "0";
            description = "Port for database, 0 means the default one";
        };

        dbUser = mkOption {
            default = "bugs";
            description = "The user name for accessing the database.";
        };

        dbPassword = mkOption {
            default = "";
            example = "foobar";
            description = ''
              The password of the database user.  Warning: this is stored in
              cleartext in the Nix store!
            '';
        };
    };
}
