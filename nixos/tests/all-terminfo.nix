import ./make-test-python.nix ({ pkgs, ... }: rec {
  name = "all-terminfo";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ jkarlson ];
  };

  nodes.machine = { pkgs, config, lib, ... }:
    let
      infoFilter = name: drv:
        let
          o = builtins.tryEval drv;
        in
        o.success &&
        lib.isDerivation o.value &&
        o.value ? outputs &&
        builtins.elem "terminfo" o.value.outputs &&
        !o.value.meta.broken;
      terminfos = lib.filterAttrs infoFilter pkgs;
      excludedTerminfos = lib.filterAttrs (_: drv: !(builtins.elem drv.terminfo config.environment.systemPackages)) terminfos;
      includedOuts = lib.filterAttrs (_: drv: builtins.elem drv.out config.environment.systemPackages) terminfos;
    in
    {
      environment = {
        enableAllTerminfo = true;
        etc."terminfo-missing".text = builtins.concatStringsSep "\n" (builtins.attrNames excludedTerminfos);
        etc."terminfo-extra-outs".text = builtins.concatStringsSep "\n" (builtins.attrNames includedOuts);
      };
    };

  testScript =
    ''
      machine.fail("grep . /etc/terminfo-missing >&2")
      machine.fail("grep . /etc/terminfo-extra-outs >&2")
    '';
})
