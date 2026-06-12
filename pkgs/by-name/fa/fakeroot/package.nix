{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  po4a,
  libcap,
  getopt,
  gnused,
  coreutils,
  versionCheckHook,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.38.1";
  pname = "fakeroot";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "clint";
    repo = "fakeroot";
    tag = "upstream/${finalAttrs.version}";
    hash = "sha256-sAzXeONjDT753lbu7amQY6yXpaTNCa4wFOzB01SRbCs=";
  };

  patches = lib.optionals stdenv.hostPlatform.isLinux [
    ./add-missing-wrapawk.patch
    ./einval.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    po4a
  ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libcap ];

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

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    tests = {
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
    hasNoMaintainersButDependents = true;
  };
})
