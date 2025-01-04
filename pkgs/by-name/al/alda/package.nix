{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "alda";
  version = "2.3.1";

  src_alda = fetchurl {
    url = "https://alda-releases.nyc3.digitaloceanspaces.com/${finalAttrs.version}/client/linux-amd64/alda";
    hash = "sha256-m4d3cLgqWmGMw0SM4J+7nvV/ytSoB7obMDiJCh3yboQ=";
  };

  src_player = fetchurl {
    url = "https://alda-releases.nyc3.digitaloceanspaces.com/${finalAttrs.version}/player/non-windows/alda-player";
    hash = "sha256-XwgOidQjnMClXPIS1JPzsVJ6c7vXwBHBAfUPX3WL8uU=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase =
    let
      binPath = lib.makeBinPath [ jre ];
    in
    ''
      install -D ${finalAttrs.src_alda} $out/bin/alda
      install -D ${finalAttrs.src_player} $out/bin/alda-player

      wrapProgram $out/bin/alda --prefix PATH : $out/bin:${binPath}
      wrapProgram $out/bin/alda-player --prefix PATH : $out/bin:${binPath}
    '';

  meta = {
    description = "Music programming language for musicians";
    homepage = "https://alda.io";
    license = lib.licenses.epl10;
    maintainers = [ lib.maintainers.ericdallo ];
    platforms = jre.meta.platforms;
  };
})
