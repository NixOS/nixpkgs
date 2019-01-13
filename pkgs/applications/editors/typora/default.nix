{ stdenv, fetchArchive, makeWrapper, electron_3, dpkg }:

stdenv.mkDerivation rec {
  name = "typora-${version}";
  version = "0.9.62";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchArchive {
    url = "https://typora.io/linux/typora_${version}_amd64.deb";
    hash = "sha512-/Ck03Rs53vzqj9AQaVq5CBxW9kcc5kPxmNFqbXTa66J6OLT+Kr+Ey5YcE8EL3uoDfW2SNfgOjJLsXzSLQhWiMQ==";
    inputs = [ dpkg ];
  };

  installPhase = ''
    mkdir -p $out/bin

    mv usr/share/typora/resources/app $out

    makeWrapper ${electron_3}/bin/electron $out/bin/typora \
      --add-flags $out/app
  '';

  meta = with stdenv.lib; {
    description = "A minimal Markdown reading & writing app";
    homepage = https://typora.io;
    license = licenses.unfree;
    maintainers = with maintainers; [
      jensbin
      yegortimoshenko
    ];
    inherit (electron_3.meta) platforms;
  };
}
