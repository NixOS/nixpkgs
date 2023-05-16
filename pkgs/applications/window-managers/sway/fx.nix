{ fetchFromGitHub, lib, sway-unwrapped }:

sway-unwrapped.overrideAttrs (oldAttrs: rec {
  pname = "swayfx";
<<<<<<< HEAD
  version = "0.3.2";
=======
  version = "0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "WillPower3309";
    repo = "swayfx";
    rev = version;
<<<<<<< HEAD
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
=======
    sha256 = "sha256-nVy7GdAnheWhjevcCPE407xWSLN8F4Le0uq2RDwv/Zc=";
  };

  meta = with lib; {
    description = "A Beautiful Sway Fork";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://github.com/WillPower3309/swayfx";
    maintainers = with maintainers; [ ricarch97 ];
    license = licenses.mit;
    platforms = platforms.linux;

    longDescription = ''
      Fork of Sway, an incredible and one of the most well established Wayland
      compositors, and a drop-in replacement for the i3 window manager for X11.
      SwayFX adds extra options and effects to the original Sway, such as rounded corners,
      shadows and inactive window dimming to bring back some of the Picom X11
      compositor functionality, which was commonly used with the i3 window manager.
    '';
  };
})
