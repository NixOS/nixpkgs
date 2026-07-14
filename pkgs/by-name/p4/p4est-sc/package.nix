{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  mpi,
  zlib,
  jansson,
  mpiCheckPhaseHook,
  debug ? false,
  mpiSupport ? true,

  # passthru.tests
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "p4est-sc";
  version = "2.8.7";

  src = fetchFromGitHub {
    owner = "cburstedde";
    repo = "libsc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oeEYNaYx1IdEWefctgUZVUa6wnb8K3z5Il2Y9MtQwBc=";
  };

  strictDeps = true;

  postPatch = ''
    echo $version > .tarball-version
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ]
  ++ lib.optional mpiSupport mpi;

  propagatedBuildInputs = [
    zlib
    jansson
  ];

  configureFlags = [
    "LDFLAGS=-lm"
  ]
  ++ lib.optionals mpiSupport [
    "--enable-mpi"
    "CC=mpicc"
  ]
  ++ lib.optional debug "--enable-debug";

  __darwinAllowLocalNetworking = mpiSupport;

  nativeCheckInputs = lib.optionals mpiSupport [
    mpiCheckPhaseHook
  ];

  doCheck = true;

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    description = "Support for parallel scientific applications";
    longDescription = ''
      The SC library provides support for parallel scientific applications.
      Its main purpose is to support the p4est software library, hence
      this package is called p4est-sc, but it works standalone, too.
    '';
    homepage = "https://www.p4est.org/";
    downloadPage = "https://github.com/cburstedde/libsc.git";
    pkgConfigModules = [ "libsc" ];
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ qbisi ];
  };
})
