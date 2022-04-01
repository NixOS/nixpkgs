{ lib, systemdUtils }:

with systemdUtils.lib;
with systemdUtils.unitOptions;
with lib;

rec {
  units = with types;
    attrsOf (submodule ({ name, config, ... }: {
      options = concreteUnitOptions;
      config = { unit = mkDefault (systemdUtils.lib.makeUnit name config); };
    }));

  services = with types; attrsOf (submodule [ { options = serviceOptions; } unitConfig stage2ServiceConfig ]);
  initrdServices = with types; attrsOf (submodule [ { options = serviceOptions; } unitConfig stage1ServiceConfig ]);

  targets = with types; attrsOf (submodule [ { options = targetOptions; } unitConfig ]);

  sockets = with types; attrsOf (submodule [ { options = socketOptions; } unitConfig ]);

  timers = with types; attrsOf (submodule [ { options = timerOptions; } unitConfig ]);

  paths = with types; attrsOf (submodule [ { options = pathOptions; } unitConfig ]);

  slices = with types; attrsOf (submodule [ { options = sliceOptions; } unitConfig ]);

  mounts = with types; listOf (submodule [ { options = mountOptions; } unitConfig mountConfig ]);

  automounts = with types; listOf (submodule [ { options = automountOptions; } unitConfig automountConfig ]);
}
