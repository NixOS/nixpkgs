{ nixos, pkgs, config, stdenv, ... }:
{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop/acpi_call.nix
    ../../../common/pc/laptop/cpu-throttling-bug.nix
    ../.
  ];

  services = {
    # This fixes the pulseaudio profiles of the Thinkpad T490.
    # The laptop contains a single audio card with 5 sub-devices. Default pulseaudio only offers a single sink
    # which can only be switched between speaker/HDMI via a manual profile change.
    # This configures a profile set for pulseaudio which offers multiple sinks corresponding to the
    # speaker + 4 HDMI ports. This allows the user to play audio streams on the speaker and any of the 4 HDMI/USB-C
    # ports at the same time.
    udev.extraRules = let
      t490ProfileSet = ./t490-profile-set.conf;
    in ''
    SUBSYSTEM!="sound", GOTO="pulseaudio_end"
    ACTION!="change", GOTO="pulseaudio_end"
    KERNEL!="card*", GOTO="pulseaudio_end"

    # Lenovo T490
    ATTRS{vendor}=="0x8086" ATTRS{device}=="0x9dc8" ATTRS{subsystem_vendor}=="0x17aa", ATTRS{subsystem_device}=="0x2279", ENV{PULSE_PROFILE_SET}="${t490ProfileSet}"

    LABEL="pulseaudio_end"
    '';
  };
}
