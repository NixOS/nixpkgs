{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  swig,
  testers,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcap-ng";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "stevegrubb";
    repo = "libcap-ng";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qcHIHG59PDPfPsXA1r4hG4QhK2qyE7AgXOwUDjIy7lE=";
  };

  # NEWS needs to exist or else the build fails
  postPatch = ''
    touch NEWS
  '';

  strictDeps = true;
  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    swig
  ];

  outputs = [
    "out"
    "dev"
    "man"
  ];

  configureFlags = [
    "--without-python"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    };
  };

  # assumption: build machine runs linux kernel 5.0 or newer
  # see https://github.com/stevegrubb/libcap-ng?tab=readme-ov-file#note-to-distributions
  doCheck = true;

  meta = {
    changelog = "https://people.redhat.com/sgrubb/libcap-ng/ChangeLog";
    description = "Library for working with POSIX capabilities";
    homepage = "https://people.redhat.com/sgrubb/libcap-ng/";
    pkgConfigModules = [ "libcap-ng" ];
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ grimmauld ];
  };
})
