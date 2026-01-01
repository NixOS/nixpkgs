import ./generic.nix {
<<<<<<< HEAD
  hash = "sha256-nhf7defhiFBHsqfZ6y+NN3TuteII6t8zCvpTsPsO+EE=";
  version = "6.20.0";
  vendorHash = "sha256-jIOV6vIkptHEuZcD/aS386o2M2AQHTjHngBxFi2tESA=";
=======
  hash = "sha256-XJp0Loaj3FFygyiIkSaMl4T0KmkNt7xtyU4nz++6yHs=";
  version = "6.18.0";
  vendorHash = "sha256-ySNeO06x8FzCH29EHbO3/ASVNSXTviyeULFrVoQwxcw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  patches = [ ];
  nixUpdateExtraArgs = [
    "--override-filename=pkgs/by-name/in/incus/package.nix"
  ];
}
