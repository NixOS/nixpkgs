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

    # dyld doesn't search $out/lib for dlopen(), use absolute paths for macOS backends
    substituteInPlace src/backends/null/null.c --replace-fail \
      '"libnullcode" LIBERASURECODE_SO_SUFFIX ".dylib"' \
      "\"$out/lib/libnullcode\" LIBERASURECODE_SO_SUFFIX \".dylib\""
    substituteInPlace src/backends/rs_vand/liberasurecode_rs_vand.c --replace-fail \
      '"liberasurecode_rs_vand" LIBERASURECODE_SO_SUFFIX ".dylib"' \
      "\"$out/lib/liberasurecode_rs_vand\" LIBERASURECODE_SO_SUFFIX \".dylib\""
    substituteInPlace src/backends/xor/flat_xor_hd.c --replace-fail \
      '"libXorcode" LIBERASURECODE_SO_SUFFIX ".dylib"' \
      "\"$out/lib/libXorcode\" LIBERASURECODE_SO_SUFFIX \".dylib\""
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
