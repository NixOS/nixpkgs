{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  python3,
  wafHook,
}:

stdenv.mkDerivation rec {
  pname = "pflask";
  version = "unstable-2018-01-23";

  src = fetchFromGitHub {
    owner = "ghedo";
    repo = pname;
    rev = "9ac31ffe2ed29453218aac89ae992abbd6e7cc69";
    hash = "sha256-bAKPUj/EipZ98kHbZiFZZI3hLVMoQpCrYKMmznpSDhg=";
  };

  patches = [
    # Pull patch pending upstream inclusion for -fno-common toolchain support:
    #  https://github.com/ghedo/pflask/pull/30
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/ghedo/pflask/commit/73ba32ec48e1e0e4a56b1bceed4635711526e079.patch";
      hash = "sha256-KVuBS7LbYJQv6NXljpSiGGja7ar7W6A6SKzkEjB1B6U=";
    })
  ];

  nativeBuildInputs = [
    python3
    wafHook
  ];

  postInstall = ''
    mkdir -p $out/bin
    cp build/pflask $out/bin
  '';

  meta = {
    description = "Lightweight process containers for Linux";
    mainProgram = "pflask";
    homepage = "https://ghedo.github.io/pflask/";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
