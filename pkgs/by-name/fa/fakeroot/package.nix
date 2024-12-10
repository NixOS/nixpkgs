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
  version = "1.36";
  pname = "fakeroot";

  src = fetchFromGitLab {
    owner = "clint";
    repo = "fakeroot";
    rev = "upstream/${finalAttrs.version}";
    domain = "salsa.debian.org";
    hash = "sha256-QNScrkX2Vffsj/I5EJO8qs5AHQ9b5s6nHLHQKUdRzLE=";
  };

  patches = lib.optionals stdenv.hostPlatform.isLinux [
    ./einval.patch

    # patches needed for musl libc, borrowed from alpine packaging.
    # it is applied regardless of the environment to prevent patchrot
    (fetchpatch {
      name = "fakeroot-no64.patch";
      url = "https://git.alpinelinux.org/aports/plain/main/fakeroot/fakeroot-no64.patch?id=f68c541324ad07cc5b7f5228501b5f2ce4b36158";
      sha256 = "sha256-NCDaB4nK71gvz8iQxlfaQTazsG0SBUQ/RAnN+FqwKkY=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    po4a
  ];
  buildInputs = lib.optional (!stdenv.hostPlatform.isDarwin) libcap;

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
