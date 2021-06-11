{ callPackage
, buildGoPackage
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./generic.nix {
  inherit buildGoPackage nvidia_x11 nvidiaGpuSupport;
  version = "1.0.7";
  sha256 = "12izilr2x9qw8dxhjqcivakwzhf6jc86g0pmxf52fr9rwaqmpc95";
}
