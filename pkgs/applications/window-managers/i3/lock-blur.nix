{
  i3lock-color,
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  libGL,
}:

i3lock-color.overrideAttrs (oldAttrs: rec {
  pname = "i3lock-blur";
  version = "2.10";

  src = fetchFromGitHub {
    owner = "karulont";
    repo = "i3lock-blur";
    rev = version;
    sha256 = "sha256-rBQHYVD9rurzTEXrgEnOziOP22D2EePC1+EV9Wi2pa0=";
  };

  patches = [
    # Pull patch pending upstream inclusion for -fno-common toolchain
    # support: https://github.com/karulont/i3lock-blur/pull/22
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/karulont/i3lock-blur/commit/ec8fe0e7f7d78bf445602ed517efd5c324bb32f7.patch";
      sha256 = "sha256-0hXUr+ZEB1tpI3xw80/hGzKyeGuna4CQmEvK6t0VBqU=";
    })
  ];

  buildInputs = oldAttrs.buildInputs ++ [ libGL ];

  meta = with lib; {
    description = "An improved screenlocker based upon XCB and PAM with background blurring filter";
    homepage = "https://github.com/karulont/i3lock-blur/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.all;
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/i3lock-blur.x86_64-darwin
  };
})
