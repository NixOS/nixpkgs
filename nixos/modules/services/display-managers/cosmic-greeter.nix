# Copyright (c) 2024, Lily Foster <lily@lily.flowers>

# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# This module was originally developed independently by lilystarlight in
# https://github.com/lilyinstarlight/nixos-cosmic and was migrated to nixpkgs by Aleksana.

{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.displayManager.cosmic-greeter;
in
{
  meta.maintainers = lib.teams.cosmic.members;

  options.services.displayManager.cosmic-greeter = {
    enable = lib.mkEnableOption "COSMIC greeter";
  };

  config = lib.mkIf cfg.enable {
    # greetd config
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          user = "cosmic-greeter";
          # set syslog identifier to cosmic-greeter to easily query logs
          command = ''${pkgs.coreutils}/bin/env XCURSOR_THEME="''${XCURSOR_THEME:-Pop}" systemd-cat -t cosmic-greeter ${lib.getExe pkgs.cosmic-comp} ${lib.getExe pkgs.cosmic-greeter}'';
        };
      };
    };

    # daemon for querying background state and such
    systemd.services.cosmic-greeter-daemon = {
      wantedBy = [ "multi-user.target" ];
      before = [ "greetd.service" ];
      serviceConfig = {
        Type = "dbus";
        BusName = "com.system76.CosmicGreeter";
        ExecStart = "${pkgs.cosmic-greeter}/bin/cosmic-greeter-daemon";
        Restart = "on-failure";
      };
    };

    # FIXME: remove this if createHome works
    # # greeter user (hardcoded in cosmic-greeter)
    # systemd.tmpfiles.rules = [
    #   "d '/var/lib/cosmic-greeter' - cosmic-greeter cosmic-greeter - -"
    # ];

    users.users.cosmic-greeter = {
      isSystemUser = true;
      home = "/var/lib/cosmic-greeter";
      createHome = true;
      group = "cosmic-greeter";
    };

    users.groups.cosmic-greeter = { };

    # required features
    hardware.graphics.enable = true;
    services.libinput.enable = true;

    # required dbus services
    services.accounts-daemon.enable = true;

    # required for authentication
    security.pam.services.cosmic-greeter = { };

    # dbus definitions
    services.dbus.packages = with pkgs; [ cosmic-greeter ];
  };
}
