{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  autoconf,
  pkg-config,
  libz,
  bzip2,
  xz,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bio-gappa";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "lczech";
    repo = "gappa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WV8PO0v+e14tyjEm+xQGveQ0Pslgeh+osEMCqF8mue0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    autoconf
  ];

  buildInputs = [
    libz
    bzip2
    xz
  ];

  patches = [
    ./fix-cstdint.patch
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      "cmake_minimum_required (VERSION 2.8.7 FATAL_ERROR)" \
      "cmake_minimum_required (VERSION 3.10  FATAL_ERROR)"
    substituteInPlace libs/genesis/CMakeLists.txt --replace-fail \
      "cmake_minimum_required (VERSION 2.8.12 FATAL_ERROR)" \
      "cmake_minimum_required (VERSION 3.10   FATAL_ERROR)"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -Dm755 ../bin/gappa $out/bin/gappa
    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = !stdenv.hostPlatform.isDarwin; # skip on Darwin - missing /libz.1.dylib in sandbox

  meta = {
    homepage = "https://github.com/lczech/gappa";
    description = "Toolkit for analyzing and visualizing phylogenetic (placement) data";
    longDescription = ''
      gappa is a collection of commands for working with phylogenetic data. Its
      main focus are evolutionary placements of short environmental sequences
      on a reference phylogenetic tree. Such data are typically produced by
      tools such as EPA-ng, RAxML-EPA or pplacer, and usually stored in jplace
      files.
    '';
    platforms = lib.platforms.all;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ bzizou ];
    mainProgram = "gappa";
  };
})
