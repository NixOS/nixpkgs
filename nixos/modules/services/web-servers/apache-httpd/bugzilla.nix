{ config, lib, pkgs, serverInfo, php, ... }:

with lib;

let

  bugzillaConfig = pkgs.writeText "bugzilla-config" ''
    $answer{'db_driver'} = 'postgresql';
    $answer{'db_host'} = '127.0.0.1';
    $answer{'db_port'} = 0;
    $answer{'db_name'} = 'bugzilla';
    $answer{'db_user'} = 'bugzilla';
    $answer{'db_pass'} = '12345';

    $answer{'urlbase'} = 'http://bugzilla.example.com/';

    $answer{'ADMIN_EMAIL'} = 'rok@garbas.si';
    $answer{'ADMIN_PASSWORD'} = '123456';
    $answer{'ADMIN_REALNAME'} = 'admin';

    $answer{'SMTP_SERVER'} = 'mail.exmaple.com';
  '';

  bugzillaEnv = pkgs.buildEnv {
    name= "bugzilla-env-4.4.5";
    paths = [
      pkgs.perlPackages.TimeDate
      pkgs.perlPackages.MathRandomISAAC
      pkgs.perlPackages.EmailAddress
      pkgs.perlPackages.TemplateToolkit
      pkgs.perlPackages.EmailMIME
      pkgs.perlPackages.EmailSend
      pkgs.perlPackages.ListMoreUtils
      pkgs.perlPackages.URI
      pkgs.perlPackages.DBI
      pkgs.perlPackages.DBDPg
      pkgs.perlPackages.DateTime
    ];
  };

  bugzilla = pkgs.stdenv.mkDerivation rec {
    name= "bugzilla-4.4.5";

    src = pkgs.fetchurl {
      url = "http://ftp.mozilla.org/pub/mozilla.org/webtools/${name}.tar.gz";
      sha256 = "19bxk3bzs300ggh1rfc7vjb7lkc2k2h4kxzw5a03nnp5pfjryq3h";
    };

    buildInputs = [ pkgs.perl ];

    buildPhase =
      ''
      '';

    installPhase =
      ''
      mkdir -p $out
      cp -R ./* $out
      rm -R $out/lib
      ln -s ${bugzillaEnv}/lib/perl5/site_perl/5.16.3 $out/lib
      ln -s /var/lib/bugzilla/data $out/data
      ln -s /var/lib/bugzilla/skins/custom $out/skins/custom 
      ln -s /var/lib/bugzilla/graphs $out/graphs
      ln -s /var/lib/bugzilla/localconfig $out/localconfig
      substituteInPlace $out/checksetup.pl --replace 'fix_all_file_permissions(!$silent);' ""
      '';
  };

in

{

  extraConfig =
    ''
    Alias / ${bugzilla}/
    <Directory ${bugzilla}>
      AddHandler cgi-script .cgi
      Options +ExecCGI
      DirectoryIndex index.cgi index.html
      AllowOverride Limit FileInfo Indexes Options
    </Directory>

    '';

  documentRoot = bugzilla;

  options = {

  };

  startupScript = pkgs.writeScript "bugzilla_startup.sh" ''
    mkdir -p /var/lib/bugzilla/data
    mkdir -p /var/lib/bugzilla/graphs
    mkdir -p /var/lib/bugzilla/skins/custom
    touch /var/lib/bugzilla/localconfig
    chown -R wwwrun:wwwrun /var/lib/bugzilla
    chmod -R 755 /var/lib/bugzilla
    PERL5LIB=${bugzilla}/lib ${bugzilla}/checksetup.pl ${bugzillaConfig}
  '';
}
