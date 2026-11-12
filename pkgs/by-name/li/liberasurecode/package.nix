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
  version = "1.8.0";

  __structuredAttrs = true;
  strictDeps = true;

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "liberasurecode";
    tag = finalAttrs.version;
    hash = "sha256-y1xdirwu7vgIICnL30R3XJmCym4pjvVf0N9L4g6gyCg=";
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

  # Required to link the test programs
  dontDisableStatic = true;

  postInstall =
    lib.optionalString (!stdenv.hostPlatform.isStatic) ''
      rm $out/lib/*.a
    ''
    + ''
      # remove useless man pages about directories
      rm doc/man/man*/_*
      # avoid installing doc/man/man3/noname
      installManPage doc/man/man*/*.*

      moveToOutput share/liberasurecode/ $doc
    '';

  # Backends are loaded with dlopen
  doCheck = !stdenv.hostPlatform.isStatic;
  checkTarget = "test";

  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "Erasure Code API library written in C with pluggable Erasure Code backends";
    homepage = "https://github.com/openstack/liberasurecode";
    license = lib.licenses.bsd2;
    teams = [ lib.teams.openstack ];
    pkgConfigModules = [ "erasurecode-1" ];
  };
})
