{
  lib,
  haskellPackages,
}:
(lib.getBin haskellPackages.cachix).overrideAttrs (old: {
  meta = (old.meta or { }) // {
    mainProgram = old.meta.mainProgram or "cachix";
  };
})
