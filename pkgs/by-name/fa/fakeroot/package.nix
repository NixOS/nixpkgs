{
  lib,
  coreutils,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  getopt,
  libcap,
  gnused,
  nixosTests,
  testers,
  autoreconfHook,
  po4a,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.37.2";
  pname = "fakeroot";

  src = fetchFromGitLab {
    owner = "clint";
    repo = "fakeroot";
    rev = "upstream/${finalAttrs.version}";
    domain = "salsa.debian.org";
    hash = "sha256-TU/9oltd+2wYums8EEDUhaIVzwPeQvW13laCrJqb5A4=";
  };

  patches = lib.optionals stdenv.hostPlatform.isLinux [
    ./einval.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    po4a
  ];
  buildInputs = lib.optional stdenv.hostPlatform.isLinux libcap;

  postUnpack = ''
    sed -i \
      -e 's@getopt@${getopt}/bin/getopt@g' \
      -e 's@sed@${gnused}/bin/sed@g' \
      -e 's@kill@${coreutils}/bin/kill@g' \
      -e 's@/bin/ls@${coreutils}/bin/ls@g' \
      -e 's@cut@${coreutils}/bin/cut@g' \
      source/scripts/fakeroot.in
  '';

  postConfigure = ''
    pushd doc
    po4a -k 0 --variable "srcdir=../doc/" po4a/po4a.cfg
    popd
  '';

  passthru = {
    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
      };
      # A lightweight *unit* test that exercises fakeroot and fakechroot together:
      nixos-etc = nixosTests.etc.test-etc-fakeroot;
    };
  };

  meta = {
    homepage = "https://salsa.debian.org/clint/fakeroot";
    description = "Give a fake root environment through LD_PRELOAD";
    mainProgram = "fakeroot";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
