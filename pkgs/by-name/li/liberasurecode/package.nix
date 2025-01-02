{
  lib,
  stdenv,
  autoreconfHook,
  doxygen,
  fetchFromGitHub,
  installShellFiles,
  testers,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "liberasurecode";
  version = "1.6.4";

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "liberasurecode";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-KYXlRjUudWhFbhyv9V1fmqwBw3/vTBfusxafaNG+Q40=";
  };

  postPatch = ''
    substituteInPlace doc/doxygen.cfg.in \
      --replace-fail "GENERATE_MAN           = NO" "GENERATE_MAN           = YES"

    substituteInPlace Makefile.am src/Makefile.am \
      --replace-fail "-Werror" ""
  '';

  nativeBuildInputs = [
    autoreconfHook
    doxygen
    installShellFiles
  ];

  buildInputs = [ zlib ];

  configureFlags = [
    "--disable-werror"
    "--enable-doxygen"
  ];

  postInstall = ''
    # remove useless man pages about directories
    rm doc/man/man*/_*
    installManPage doc/man/man*/*

    moveToOutput share/liberasurecode/ $doc
  '';

  checkTarget = "test";

  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
  };

  meta = with lib; {
    description = "Erasure Code API library written in C with pluggable Erasure Code backends";
    homepage = "https://github.com/openstack/liberasurecode";
    license = licenses.bsd2;
    maintainers = teams.openstack.members;
    pkgConfigModules = [ "erasurecode-1" ];
  };
})
