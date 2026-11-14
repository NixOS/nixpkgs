{
  lib,
  stdenv,
  fetchFromGitHub,
  libx11,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hhpc";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "aktau";
    repo = "hhpc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WidwqI39fMKOiIM6smJrHoaRlGPC+pVB/wZWNHLgWrY=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libx11 ];

  installPhase = ''
    mkdir -p $out/bin
    cp hhpc $out/bin/
  '';

  meta = {
    description = "Hides the mouse pointer in X11";
    homepage = "https://github.com/aktau/hhpc";
    maintainers = with lib.maintainers; [ nico202 ];
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd3;
    mainProgram = "hhpc";
  };
})
