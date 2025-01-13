{
  lib,
  stdenv,
  fetchurl,
  zlib,
  installShellFiles,
}:

stdenv.mkDerivation rec {
  pname = "pngcheck";
  version = "3.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/png-mng/pngcheck-${version}.tar.gz";
    sha256 = "sha256-DX4mLyQRb93yhHqM61yS2fXybvtC6f/2PsK7dnYTHKc=";
  };

  hardeningDisable = [ "format" ];

  postPatch = ''
    substituteInPlace $makefile \
      --replace "gcc" "$CC"
  '';

  makefile = "Makefile.unx";
  makeFlags = [ "ZPATH=${zlib.static}/lib" ];

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ zlib ];

  installPhase = ''
    runHook preInstall
    install -Dm555 -t $out/bin/ pngcheck
    installManPage $pname.1
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://pmt.sourceforge.net/pngcrush";
    description = "Verifies the integrity of PNG, JNG and MNG files";
    license = licenses.free;
    platforms = platforms.unix;
    maintainers = with maintainers; [ starcraft66 ];
    mainProgram = "pngcheck";
  };
}
