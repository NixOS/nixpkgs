{ config, lib, pkgs, ... }:
let
  phabricatorRoot = pkgs.stdenv.mkDerivation rec {
    version = "2014-05-12";
    name = "phabricator-${version}";
    srcLibphutil = pkgs.fetchgit {
        url = git://github.com/facebook/libphutil.git;
        rev = "2f3b5a1cf6ea464a0250d4b1c653a795a90d2716";
        sha256 = "9598cec400984dc149162f1e648814a54ea0cd34fcd529973dc83f5486fdd9fd";
    };
    srcArcanist = pkgs.fetchgit {
        url = git://github.com/facebook/arcanist.git;
        rev = "54c377448db8dbc40f0ca86d43c837d30e493485";
        sha256 = "086db3c0d1154fbad23e7c6def31fd913384ee20247b329515838b669c3028e0";
    };
    srcPhabricator = pkgs.fetchgit {
        url = git://github.com/facebook/phabricator.git;
        rev = "1644ef185ecf1e9fca3eb6b16351ef46b19d110f";
        sha256 = "e1135e4ba76d53f48aad4161563035414ed7e878f39a8a34a875a01b41b2a084";
    };
    
    buildCommand = ''
      mkdir -p $out
      cp -R ${srcLibphutil} $out/libphutil
      cp -R ${srcArcanist} $out/arcanist
      cp -R ${srcPhabricator} $out/phabricator
    '';
  };
in {
  enablePHP = true;
  extraApacheModules = [ "mod_rewrite" ];
  DocumentRoot = "${phabricatorRoot}/phabricator/webroot";
  extraConfig = ''
      DocumentRoot ${phabricatorRoot}/phabricator/webroot

      RewriteEngine on
      RewriteRule ^/rsrc/(.*) - [L,QSA]
      RewriteRule ^/favicon.ico - [L,QSA]
      RewriteRule ^(.*)$ /index.php?__path__=$1 [B,L,QSA]
  '';
}
