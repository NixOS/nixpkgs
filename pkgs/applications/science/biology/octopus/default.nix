{lib, stdenv, fetchpatch, fetchFromGitHub, cmake, boost, gmp, htslib, zlib, xz, pkg-config}:

stdenv.mkDerivation rec {
  pname = "octopus";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "luntergroup";
    repo = "octopus";
    rev = "v${version}";
    sha256 = "sha256-sPOBZ0YrEdjMNVye/xwqwA5IpsLy2jWN3sm/ce1fLg4=";
  };

  patches = [
    # Backport TZ patchs (https://github.com/luntergroup/octopus/issues/149)
    (fetchpatch {
      url = "https://github.com/luntergroup/octopus/commit/3dbd8cc33616129ad356e99a4dae82e4f6702250.patch";
      sha256 = "sha256-UCufVU9x+L1zCEhkr/48KFYRvh8w26w8Jr+O+wULKK8=";
    })
    (fetchpatch {
      url = "https://github.com/luntergroup/octopus/commit/af5a66a2792bd098fb53eb79fb4822625f09305e.patch";
      sha256 = "sha256-r8jv6EZHfTWVLYUBau3F+ilOd9IeH8rmatorEY5LXP4=";
    })
  ];

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ boost gmp htslib zlib xz ];

  postInstall = ''
    mkdir $out/bin
    mv $out/octopus $out/bin
  '';

  meta = with lib; {
    description = "Bayesian haplotype-based mutation calling";
    license = licenses.mit;
    homepage = "https://github.com/luntergroup/octopus";
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.x86_64;
  };
}
