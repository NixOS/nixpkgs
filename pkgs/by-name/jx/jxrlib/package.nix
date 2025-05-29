{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  ninja,
  quilt,
}:

stdenv.mkDerivation {
  pname = "jxrlib";
  version = "1.2~git20170615.f752187-5.2";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian-phototools-team";
    repo = "jxrlib";
    rev = "56e10e601a962c2e8d178e60e52cd8cf2d50f9c0";
    hash = "sha256-BX4kLlFk8AfouKE9KDyG1EFFYLFB/HqYQRxFdjAe2J8=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    quilt
  ];

  strictDeps = true;

  env.NIX_CFLAGS_COMPILE = lib.concatStringsSep " " (
    [ "-Wno-error=implicit-function-declaration" ]
    ++ lib.optionals stdenv.cc.isGNU [ "-Wno-error=incompatible-pointer-types" ]
  );

  postPatch = ''
    QUILT_PATCHES=debian/patches quilt push -a
  '';

  meta = with lib; {
    description = "Implementation of the JPEG XR image codec standard";
    homepage = "https://jxrlib.codeplex.com";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ romildo ];
  };
}
