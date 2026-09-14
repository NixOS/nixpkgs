# Activation scripts are deprecated, see
# https://github.com/NixOS/nixpkgs/issues/475305
#
# This module warns about any activation script that is not on the
# exemption list below. The list contains the scripts that are still
# defined by NixOS itself, it should only ever shrink. Do NOT add new
# entries, add a systemd unit instead.
#
# The warning will eventually become an assertion.
{ config, lib, ... }:

let
  exemptions = [
    "binsh"
    "etc"
    "groups"
    "hashes"
    "modprobe"
    "specialfs"
    "udevd"
    "users"
    "usrbinenv"
  ];

  scriptText = value: if lib.isString value then value else value.text;

  offenders = lib.attrNames (
    lib.filterAttrs (name: value: !(lib.elem name exemptions) && scriptText value != "") (
      lib.removeAttrs config.system.activationScripts [ "script" ]
    )
  );
in

{
  meta.maintainers = with lib.maintainers; [ rvdp ];

  config = {
    warnings = lib.optional (offenders != [ ]) ''
      Activation scripts are deprecated and will be removed soon.
      See https://github.com/NixOS/nixpkgs/issues/475305 for alternatives.
      The following activation scripts are defined:
      ${lib.concatMapStringsSep "\n" (name: "- system.activationScripts.${name}") offenders}
    '';
  };
}
