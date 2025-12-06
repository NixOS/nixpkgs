{
  lib,
  bash,
}:

let
  bashNonInteractive = lib.lowPrio (
    bash.override {
      interactive = false;
    }
  );
in
bashNonInteractive
