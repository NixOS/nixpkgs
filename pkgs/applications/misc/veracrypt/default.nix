{ fetchurl, stdenv, pkgconfig, yasm, fuse, wxGTK30, devicemapper, makeself,
  wxGUI ? true
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "veracrypt-${version}";
  version = "1.21";

  src = fetchurl {
    url = "https://launchpad.net/veracrypt/trunk/${version}/+download/VeraCrypt_${version}_Source.tar.bz2";
    sha256 = "0n036znmwnv70wy8r2j3b55bx2z3cch5fr83vnwjvzyyp0j7swa4";
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
    homepage = https://veracrypt.codeplex.com/;
    license = "VeraCrypt License";
    maintainers = with maintainers; [ dsferruzza ];
    platforms = platforms.linux;
  };
}
