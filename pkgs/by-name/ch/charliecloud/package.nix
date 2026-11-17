{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  docker,
  autoreconfHook,
  coreutils,
  makeWrapper,
  gnused,
  gnutar,
  gzip,
  findutils,
  sudo,
  nixosTests,
  pkg-config,
  fuse3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "charliecloud";
  version = "0.38";

  src = fetchFromGitHub {
    owner = "hpc";
    repo = "charliecloud";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Mr2Qa1PRTarJ0I8nkH/Xsq8QN3OxOfL8tpl1lL1WV0c=";
  };

  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    docker
    fuse3
    (python3.withPackages (ps: [
      ps.lark
      ps.requests
    ]))
  ];

  configureFlags =
    let
      pythonEnv = python3.withPackages (ps: [
        ps.lark
        ps.requests
      ]);
    in
    [
      "--with-python=${pythonEnv}/bin/python3"
      "-disable-bundled-lark"
    ];

  preConfigure = ''
    patchShebangs test/
    substituteInPlace configure.ac --replace-fail "/usr/bin/env" "${coreutils}/bin/env"
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "LIBEXEC_DIR=lib/charliecloud"
  ];

  # Charliecloud calls some external system tools.
  # Here we wrap those deps so they are resolved inside nixpkgs.
  postInstall = ''
    for file in $out/bin/* ; do \
      wrapProgram $file --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          docker
          gnused
          gnutar
          gzip
          findutils
          sudo
        ]
      }
    done
  '';

  passthru.tests.charliecloud = nixosTests.charliecloud;

  meta = {
    description = "User-defined software stacks (UDSS) for high-performance computing (HPC) centers";
    longDescription = ''
      Charliecloud uses Linux user namespaces to run containers with no
      privileged operations or daemons and minimal configuration changes on
      center resources. This simple approach avoids most security risks
      while maintaining access to the performance and functionality already
      on offer.
    '';
    homepage = "https://hpc.github.io/charliecloud";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.bzizou ];
    platforms = lib.platforms.linux;
  };
})
