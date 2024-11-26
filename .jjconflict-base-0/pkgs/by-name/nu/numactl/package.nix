{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "numactl";
  version = "2.0.18";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ry29RUNa0Hv5gIhy2RTVT94mHhgfdIwb5aqjBycxxj0=";
  };

  patches = [
    # Fix for memory corruption in set_nodemask_size
    (fetchpatch {
      url = "https://github.com/numactl/numactl/commit/f9deba0c8404529772468d6dd01389f7dbfa5ba9.patch";
      hash = "sha256-TmWfD99YaSIHA5PSsWHE91GSsdsVgVU+qIow7LOwOGw=";
    })
  ];

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

  meta = with lib; {
    description = "Library and tools for non-uniform memory access (NUMA) machines";
    homepage = "https://github.com/numactl/numactl";
    license = with licenses; [
      gpl2Only
      lgpl21
    ]; # libnuma is lgpl21
    platforms = platforms.linux;
  };
}
