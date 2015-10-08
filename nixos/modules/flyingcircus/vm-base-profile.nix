{ config, lib, pkgs, ... }:

with lib;

{
  environment.noXlibs = true;
  sound.enable = false;

  environment.systemPackages = [
      pkgs.cyrus_sasl
      pkgs.db
      pkgs.dstat
      pkgs.gcc
      pkgs.libxml2
      pkgs.libxslt
      pkgs.mercurial
      pkgs.git
      pkgs.openssl
      pkgs.python27
      pkgs.python27Packages.virtualenv
      pkgs.vim
      pkgs.zlib
  ];

  environment.pathsToLink = [ "/include" ];
  environment.shellInit = ''
   # help pip to find libz.so when building lxml
   export LIBRARY_PATH=/var/run/current-system/sw/lib
   # ditto for header files, e.g. sqlite
   export C_INCLUDE_PATH=/var/run/current-system/sw/include:/var/run/current-system/sw/include/sasl
  '';

}
