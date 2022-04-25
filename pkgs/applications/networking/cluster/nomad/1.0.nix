{ callPackage
, buildGoPackage
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./generic.nix {
  inherit buildGoPackage nvidia_x11 nvidiaGpuSupport;
  version = "1.0.18";
  sha256 = "0bnp3i391zv9zd5rj6br7zki3920k016wj92sqs32nrwsx3bns20";
}
