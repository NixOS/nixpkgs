{
  lib,
  stdenv,
  fetchurl,
  zlib,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pngcheck";
  version = "3.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/png-mng/pngcheck-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-DX4mLyQRb93yhHqM61yS2fXybvtC6f/2PsK7dnYTHKc=";
  };

  hardeningDisable = [ "format" ];

  postPatch = ''
    substituteInPlace $makefile \
      --replace "gcc" "$CC"
  '';

  makefile = "Makefile.unx";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ zlib ];

  installPhase = ''
    runHook preInstall
    installBin pngcheck
    installManPage $pname.1
    runHook postInstall
  '';

  meta = {
    homepage = "https://pmt.sourceforge.net/pngcrush";
    description = "Verifies the integrity of PNG, JNG and MNG files";
    license = lib.licenses.free;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ starcraft66 ];
    mainProgram = "pngcheck";
  };
})
