{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "numactl";
  version = "2.0.19";

  src = fetchFromGitHub {
    owner = "numactl";
    repo = "numactl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-88fxc7u7l7n0WLZ56vDmvdAoh8BaKTXUHWfqCycyoOw=";
  };

  outputs = [
    "out"
    "dev"
    "man"
  ];

  nativeBuildInputs = [ autoreconfHook ];

  postPatch = ''
    patchShebangs test
  '';

  # You probably shouldn't ever run these! They will reconfigure Linux
  # NUMA settings, which on my build machine makes the rest of package
  # building ~5% slower until reboot. Ugh!
  doCheck = false; # never ever!

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Library and tools for non-uniform memory access (NUMA) machines";
    homepage = "https://github.com/numactl/numactl";
    license = with lib.licenses; [
      gpl2Only
      lgpl21
    ]; # libnuma is lgpl21
    maintainers = with lib.maintainers; [ VZstless ];
    platforms = lib.platforms.linux;
  };
})
