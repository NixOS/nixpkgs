{
  lib,
  emptyFile,
  nixos,
}:
let
  evalModuleStateRevisions =
    cfg:
    (nixos [
      { system.stateVersion = lib.trivial.release; }
      cfg
    ]).config.system.moduleStateRevisions;
in
assert evalModuleStateRevisions { } == { };
emptyFile
