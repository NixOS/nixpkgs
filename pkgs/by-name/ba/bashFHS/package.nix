{ bash }:
let
  bashFHS = bash.override {
    forFHSEnv = true;
  };
in
bashFHS
