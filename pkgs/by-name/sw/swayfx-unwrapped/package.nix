{
  lib,
  fetchFromGitHub,
  sway-unwrapped,
  stdenv,
  systemd,
  # Used by the NixOS module:
  isNixOS ? false,
  enableXWayland ? true,
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd,
  trayEnabled ? systemdSupport,
}:

(sway-unwrapped.override {
  inherit
    isNixOS
    enableXWayland
    systemdSupport
    trayEnabled
    ;
}).overrideAttrs (oldAttrs: rec {
  pname = "swayfx-unwrapped";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "WillPower3309";
    repo = "swayfx";
    rev = version;
    sha256 = "sha256-Gwewb0yDVhEBrefSSGDf1hLtpWcntzifPCPJQhqLqI0=";
  };

  # This patch was backported into SwayFX
  # remove when next release is rebased on Sway 1.9
  patches =
    let
      removePatches = [
        "LIBINPUT_CONFIG_ACCEL_PROFILE_CUSTOM.patch"
      ];
    in
    builtins.filter
      (patch: !builtins.elem (patch.name or null) removePatches)
      (oldAttrs.patches or [ ]);

  meta = with lib; {
    description = "Sway, but with eye candy!";
    homepage = "https://github.com/WillPower3309/swayfx";
    license = licenses.mit;
    maintainers = with maintainers; [ eclairevoyant ricarch97 ];
    platforms = platforms.linux;
    mainProgram = "sway";

    longDescription = ''
      Fork of Sway, an incredible and one of the most well established Wayland
      compositors, and a drop-in replacement for the i3 window manager for X11.
      SwayFX adds extra options and effects to the original Sway, such as rounded corners,
      shadows and inactive window dimming to bring back some of the Picom X11
      compositor functionality, which was commonly used with the i3 window manager.
    '';
  };
})
