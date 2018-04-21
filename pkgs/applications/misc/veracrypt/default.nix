{ fetchurl, stdenv, pkgconfig, yasm, fuse, wxGTK30, devicemapper, makeself,
  wxGUI ? true
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "veracrypt-${version}";
  version = "1.22";

  src = fetchurl {
    url = "https://launchpad.net/veracrypt/trunk/${version}/+download/VeraCrypt_${version}_Source.tar.bz2";
    sha256 = "0w5qyxnx03vn93ach1kb995w2mdg43s82gf1isbk206sxp00qk4y";
  };

  unpackPhase =
    ''
      tar xjf $src
      cd src
    '';

  nativeBuildInputs = [ makeself yasm pkgconfig ];
  buildInputs = [ fuse devicemapper ]
    ++ optional wxGUI wxGTK30;
  makeFlags = optionalString (!wxGUI) "NOGUI=1";

  installPhase =
    ''
      mkdir -p $out/bin
      cp Main/veracrypt $out/bin
      mkdir -p $out/share/$name
      cp License.txt $out/share/$name/LICENSE
      mkdir -p $out/share/applications
      sed "s,Exec=.*,Exec=$out/bin/veracrypt," Setup/Linux/veracrypt.desktop > $out/share/applications/veracrypt.desktop
    '';

  meta = {
    description = "Free Open-Source filesystem on-the-fly encryption";
    homepage = https://www.veracrypt.fr/;
    license = "VeraCrypt License";
    maintainers = with maintainers; [ dsferruzza ];
    platforms = platforms.linux;
  };
}
