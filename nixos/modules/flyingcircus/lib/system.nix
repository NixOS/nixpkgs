/*
 * generic system state functions for use in all of the flyingcircus Nix stuff
 */

{ lib, fclib, ... }:

{

  # Return the currently available memory. That is the minimum of the "should"
  # and the "actual" memory.
  current_memory = config: default:
    let
      cfg = config.flyingcircus;
      enc_memory =
        if lib.hasAttrByPath ["parameters" "memory"] cfg.enc
        then cfg.enc.parameters.memory
        else null;
      system_memory =
        if lib.hasAttr "memory" cfg.system_state
        then cfg.system_state.memory
        else null;
      options = lib.remove null [enc_memory system_memory];
    in
      if options == []
      then default
      else fclib.min options;

  current_cores = config: default:
    let
      cfg = config.flyingcircus;
    in
      if cfg.system_state ? cores
      then cfg.system_state.cores
      else default;
}
