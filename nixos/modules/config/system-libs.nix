# This module defines the packages that appear in
# /run/current-system/sw.

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.libraries;

  system = pkgs.stdenv.system;
  system32 = pkgs.pkgsi686Linux.stdenv.system;

  pathsToLink = [ "/lib" "/share" "/etc" ];

  mkLibPath = paths: pkgs.buildEnv {
    name = "libraries";
    inherit paths pathsToLink;
    ignoreCollisions = true;
  };

  mkSanitized = paths: pkgs.buildEnv {
    name = "sanitized-libraries";
    inherit paths pathsToLink;
    ignoreCollisions = true;
    postBuild = ''
      for i in $out/lib/*; do
        if [ -f "$(readlink -f "$i")" ]; then
          rm "$i"
        fi
      done
    '';
  };

  libPkgs = zipAttrsWith (name: mkLibPath) cfg.unsafePackages;

  libPath = libPkgs.${system};
  libPath32 = libPkgs.${system32};

  # We use more "stable" absolute paths in systemd environment and symlinks for users.
  mkEnv = path: path32: mapAttrs (name: concatMap (suffix: [ "${path}/${suffix}" ] ++ optional cfg.support32Bit "${path32}/${suffix}")) cfg.environment;

in

{
  options = {

    libraries = {

      packages = mkOption {
        type = types.listOf (types.attrsOf types.package);
        default = [];
        example = literalExample "with pkgs_multiarch; [ mesa ]";
        description = ''
          The set of packages that appear in
          <filename>/run/current-system/''${system}-lib</filename>
          for each supported architecture. They are supposed
          to be arch-dependent library plugins, like DRI drivers,
          input methods etc.

	  <note><para>Packages placed here are stripped of files in
          <filename>/lib</filename> to avoid library path contamination.</para></note>
        '';
      };

      unsafePackages = mkOption {
        type = types.listOf (types.attrsOf types.package);
        example = literalExample "with pkgs_multiarch; [ mesa ]";
        internal = true;
        description = ''
          Packages which get into <literal>LD_LIBRARY_PATH</literal>.
        '';
      };

      environment = mkOption {
        type = types.attrsOf (types.listOf types.str);
        default = {};
        example = { "LD_LIBRARY_PATH" = [ "lib" ]; };
        description = ''
          Relative environment variables that need to be pointed to the libraries.
	  Each entry has path to libraries prepended for each architecture and
          concatenated with a colon.
        '';
      };

      support32Bit = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to support 32-bit binaries on a 64-bit system.
        '';
      };

    };

  };

  config = {

    assertions = lib.singleton {
      assertion = cfg.support32Bit -> pkgs.stdenv.isx86_64;
      message = "Option support32Bit only makes sense on a 64-bit system.";
    };

    systemd.globalEnvironment = mkEnv libPath libPath32;
    environment.sessionVariables = mkEnv "/run/current-system/${system}-lib" "/run/current-system/${system32}-lib";

    libraries.environment."LD_LIBRARY_PATH" = [ "lib" ]; # FIXME: remove when libglvnd allows us to have fully dynamic OpenGL dispatch.
    libraries.unsafePackages = [ (zipAttrsWith (name: mkSanitized) cfg.packages) ];

    system.extraSystemBuilderCmds = ''
      ln -s ${libPath} $out/${system}-lib
      ${optionalString cfg.support32Bit ''
        ln -s ${libPath32} $out/${system32}-lib
      ''}
    '';

  };
}
