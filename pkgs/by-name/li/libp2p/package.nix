{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libp2p";
  version = "unstable-2026-06-05";

  src = fetchFromGitHub {
    owner = "sekrit-twc";
    repo = "libp2p";
    rev = "869fa993041f9f3af7d9ac8b10158920c6ddce66";
    sha256 = "sha256-84mCTO8MFWAcQ5WVC5W5w1a7caBQnMZ3pfRF6PbuSZg";
  };

  strictDeps = true;
  __structuredAttrs = true;

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail 'p2p_api.o' 'p2p_api.o v210.o'
  '';

  postBuild = ''
    cat > libp2p.pc <<EOF
    Name: libp2p
    Description: Pack/unpack pixels
    Version: ${finalAttrs.version}
    Libs: -L$out/lib -lp2p
    Cflags: -I$out/include
    EOF
  '';

  installPhase = ''
    runHook preInstall
    install -Dt "$out/lib" libp2p.a
    install -Dt "$out/include" *.h
    install -Dt "$out/lib/pkgconfig" *.pc
    runHook postInstall
  '';

  meta = {
    description = "Pack/unpack pixels";
    homepage = "https://github.com/sekrit-twc/libp2p";
    license = lib.licenses.wtfpl;
    platforms = with lib.platforms; unix ++ windows;
    maintainers = with lib.maintainers; [ rnhmjoj ];
  };
})
