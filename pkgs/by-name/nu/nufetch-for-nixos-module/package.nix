{
  lib,
  stdenv,
  pkgs,
  nixosTests,
}:

pkgs.neofetch.overrideAttrs (old: {
  pname = "nufetch-for-nixos-module";
  patches = (old.patches or [ ]) ++ [ ./patches/neofetch-nixos-module.patch ];
  meta = old.meta // {
    description = "A patched version of neofetch for the nufetch NixOS module";
    homepage = "https://github.com/gignsky/nufetch";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ gignsky ];
  };
  passthru.tests = {
    nufetch = nixosTests.nufetch;
  };
})
