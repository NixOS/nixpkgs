{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  SDL,
  SDL_image,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "airstrike";
  version = "pre6a";

  src = fetchurl {
    url = "https://icculus.org/airstrike/airstrike-${finalAttrs.version}-src.tar.gz";
    sha256 = "1h6rv2zcp84ycmd0kv1pbpqjgwx57dw42x7878d2c2vnpi5jn8qi";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    SDL
    SDL_image
  ];

  env.NIX_LDFLAGS = "-lm";

  installPhase = ''
    mkdir -p $out/bin
    cp airstrike $out/bin

    mkdir -p $out/share
    cp -r data airstrikerc $out/share

    wrapProgram $out/bin/airstrike \
      --chdir "$out/share"
  '';

  meta = {
    description = "2d dogfighting game";
    mainProgram = "airstrike";
    homepage = "https://icculus.org/airstrike/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ pSub ];
    platforms = lib.platforms.linux;
  };
})
