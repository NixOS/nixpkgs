{ config, lib, pkgs, ... }:

with lib;

let
  resource-manager = pkgs.stdenv.mkDerivation {
    name = "resource-manager";
    buildInputs = with pkgs; [ openssl attr libbsd ];
    buildCommand = ''
      mkdir -p $out/bin
      gcc -O2 -Wall -lssl -lbsd -o $out/bin/resource-manager ${./resource-manager.c}
    '';
  };

in

{

  options.nixup.enable = mkEnableOption "NixUP";

  config = mkIf config.nixup.enable {
    security.wrappers = {
      resource-manager.source = "${resource-manager}/bin/resource-manager";
    };

    environment.systemPackages = [ config.system.build.nixup-rebuild resource-manager ];

    environment.sessionVariables = {
      NIXUP_USER_PROFILE_DIR = "/nix/var/nix/profiles/nixup/\${USER}";
    };

    security.pam.services =
    let
      sessionCommand = ''
        PATH=${pkgs.coreutils}/bin:$PATH

        # Set up the per-user profile.
        NIXUP_USER_PROFILE_DIR=/nix/var/nix/profiles/nixup/$PAM_USER
        if ! test -e $NIXUP_USER_PROFILE_DIR; then
            mkdir -m 0755 -p $NIXUP_USER_PROFILE_DIR
            chown $(id -u $PAM_USER):$(id -g $PAM_USER) $NIXUP_USER_PROFILE_DIR
        fi

        if test "$(stat --printf '%u' $NIXUP_USER_PROFILE_DIR)" != "$(id -u $PAM_USER)"; then
            echo "WARNING: bad ownership on $NIXUP_USER_PROFILE_DIR" >&2
        fi

        # Set up the per-user gcroot.
        NIXUP_USER_GCROOTS_DIR=/nix/var/nix/gcroots/nixup/$PAM_USER
        if ! test -e $NIXUP_USER_GCROOTS_DIR; then
            mkdir -m 0755 -p $NIXUP_USER_GCROOTS_DIR
            chown $(id -u $PAM_USER):$(id -g $PAM_USER) $NIXUP_USER_GCROOTS_DIR
        fi

        if test "$(stat --printf '%u' $NIXUP_USER_GCROOTS_DIR)" != "$(id -u $PAM_USER)"; then
            echo "WARNING: bad ownership on $NIXUP_USER_GCROOTS_DIR" >&2
        fi

        # Activate nixup user profile.
        if test -e $NIXUP_USER_PROFILE_DIR/default/activate; then
            ${pkgs.sudo}/bin/sudo -u $PAM_USER -H NIXUP_RUNTIME_DIR="/run/user/$(id -u $PAM_USER)/nixup" $NIXUP_USER_PROFILE_DIR/default/activate
        fi
      '';
    in
    {
      systemd-user = { sessionCommands = sessionCommand; };
    };

  };

}
