{ fetchFromGitHub, lib, sway-unwrapped }:

sway-unwrapped.overrideAttrs (oldAttrs: rec {
  pname = "swayfx";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "WillPower3309";
    repo = "swayfx";
    rev = version;
    sha256 = "sha256-nVy7GdAnheWhjevcCPE407xWSLN8F4Le0uq2RDwv/Zc=";
  };

  meta = with lib; {
    description = "A Beautiful Sway Fork";
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
