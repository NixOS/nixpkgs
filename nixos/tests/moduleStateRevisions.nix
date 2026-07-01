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

  # For modules that follow the <module>.enable, <module>.stateRevision pattern:
  testModule =
    path:
    evalModuleStateRevisions (lib.setAttrByPath path { enable = true; })
    ? "${builtins.concatStringsSep "." path}.stateRevision";
in
assert evalModuleStateRevisions { } == { };
assert testModule [
  "services"
  "seerr"
];
emptyFile
