{
  stdenv,
  lib,
  fetchFromGitHub,
  buildPackages,
  alsa-lib,
  libx11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "minivmac-erichelgeson";
  version = "2024.06.08";

  src = fetchFromGitHub {
    owner = "erichelgeson";
    repo = "minivmac";
    rev = finalAttrs.version;
    hash = "sha256-iiEE0ioXh3keKUPfAB+YcE1iggGLpxT9N8LSVFDhttE=";
  };

  buildInputs = [ libx11 ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  configurePhase = ''
    runHook preConfigure

    ${lib.getExe' buildPackages.stdenv.cc "cc"} setup/tool.c -o setup_t
    ./setup_t -t lx64 > setup.sh

    # Patch hardcoded references in setup.sh to cross-aware counterparts
    substituteInPlace setup.sh --replace 'gcc ' '${stdenv.cc.targetPrefix}cc '
    substituteInPlace setup.sh --replace 'strip --strip-unneeded' '${stdenv.cc.targetPrefix}strip --strip-unneeded'

    sh < ./setup.sh

    runHook postConfigure
  '';

  installPhase = ''
    install -Dm755 -t $out/bin ./minivmac
  '';

  # ensure libasound can be dlopen()'ed
  postFixup = ''
    patchelf --add-rpath "${lib.getLib alsa-lib}/lib" $out/bin/minivmac
  '';

  meta = {
    description = "Miniature early Macintosh emulator (fork from erichelgeson)";
    homepage = "https://github.com/erichelgeson/minivmac";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.flokli ];
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
