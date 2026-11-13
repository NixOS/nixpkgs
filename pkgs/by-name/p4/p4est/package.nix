{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  metis,
  p4est-sc,
  mpi,
  mpiCheckPhaseHook,
  debug ? false,
  withMetis ? true,
  mpiSupport ? true,

  # passthru.tests
  testers,
}:
let
  p4est-sc' = p4est-sc.override { inherit mpi mpiSupport debug; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "p4est";
  version = "2.8.7";

  src = fetchFromGitHub {
    owner = "cburstedde";
    repo = "p4est";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8JvKaYOP4IO1Xmim74KNHvMLOV3y9VRoT76RBCaRyhI=";
  };

  strictDeps = true;

  postPatch = ''
    echo $version > .tarball-version

    substituteInPlace Makefile.am \
      --replace-fail "@P4EST_SC_AMFLAGS@" "-I ${p4est-sc}/share/aclocal"
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ]
  ++ lib.optional mpiSupport mpi;

  buildInputs = [
    metis
  ];

  propagatedBuildInputs = [ p4est-sc' ];

  configureFlags = [
    "--with-sc=${p4est-sc'}"
    "--with-metis"
    "--enable-p6est"
    "LDFLAGS=-lm"
  ]
  ++ lib.optionals mpiSupport [
    "--enable-mpi"
    "CC=mpicc"
  ]
  ++ lib.optional debug "--enable-debug";

  doCheck = true;

  __darwinAllowLocalNetworking = mpiSupport;

  nativeCheckInputs = lib.optionals mpiSupport [
    mpiCheckPhaseHook
  ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    description = "Parallel AMR on Forests of Octrees";
    longDescription = ''
      The p4est software library provides algorithms for parallel AMR.
      AMR refers to Adaptive Mesh Refinement, a technique in scientific
      computing to cover the domain of a simulation with an adaptive mesh.
    '';
    homepage = "https://www.p4est.org/";
    downloadPage = "https://github.com/cburstedde/p4est.git";
    pkgConfigModules = [ "p4est" ];
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ qbisi ];
  };
})
