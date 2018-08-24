{ ... }:

let
  shim = {
    boot.loader.systemd-boot.enable = true;

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/00000000-0000-0000-0000-000000000000";
      fsType = "btrfs";
    };

    nixpkgs.config = {
      allowBroken = true;
      allowUnfree = true;
    };
  };

  buildProfile = profile: (import <nixpkgs/nixos> {
    configuration.imports = [ profile shim ];
  }).system;
in

{
  acer-aspire-4810t = buildProfile ./acer/aspire/4810t;

  airis-n990 = buildProfile ./airis/n990;

  apple-macbook-air-4 = buildProfile ./apple/macbook-air/4;
  apple-macbook-air-6 = buildProfile ./apple/macbook-air/6;
  apple-macbook-pro-10-1 = buildProfile ./apple/macbook-pro/10-1;
  apple-macbook-pro-11-5 = buildProfile ./apple/macbook-pro/11-5;
  apple-macbook-pro-12-1 = buildProfile ./apple/macbook-pro/12-1;

  dell-xps-15-9550 = buildProfile ./dell/xps/15-9550;

  lenovo-thinkpad-t410 = buildProfile ./lenovo/thinkpad/t410;
  lenovo-thinkpad-t440p = buildProfile ./lenovo/thinkpad/t440p;
  lenovo-thinkpad-t460s = buildProfile ./lenovo/thinkpad/t460s;
  lenovo-thinkpad-x140e = buildProfile ./lenovo/thinkpad/x140e;
  lenovo-thinkpad-x220 = buildProfile ./lenovo/thinkpad/x220;
  lenovo-thinkpad-x230 = buildProfile ./lenovo/thinkpad/x230;
  lenovo-thinkpad-x250 = buildProfile ./lenovo/thinkpad/x250;

  microsoft-surface-pro-3 = buildProfile ./microsoft/surface-pro/3;

  pcengines-apu = buildProfile ./pcengines/apu;

  toshiba-swanky = buildProfile ./toshiba/swanky;
}
