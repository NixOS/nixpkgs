{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
}:
stdenv.mkDerivation rec {
  pname = "farmhash";
  version = "1.1-${lib.substring 0 8 src.rev}";

  src = fetchFromGitHub {
    owner = "google";
    repo = "farmhash";
    rev = "0d859a811870d10f53a594927d0d0b97573ad06d";
    hash = "sha256-J0AhHVOvPFT2SqvQ+evFiBoVfdHthZSBXzAhUepARfA=";
  };

  patches = [
    # remove if https://github.com/google/farmhash/pull/25 is merged
    (fetchpatch {
      name = "remove-using-namespace-std.patch";
      url = "https://github.com/yasushi-saito/farmhash/commit/a9f371c8d7ba46824ee73331c241a206f7ed6381.diff";
      hash = "sha256-xDD+mhvkJNIsIbhym+xhOtSrIzqtbgKpehgfPxFbEv0=";
    })
  ];

  doCheck = true;

  meta = with lib; {
    description = "FarmHash, a family of hash functions.";
    homepage = "https://github.com/google/farmhash";
    platforms = platforms.all;
    license = lib.licenses.mit;
    maintainers = with maintainers; [
      mschwaig
      crazychaoz
    ];
  };
}
