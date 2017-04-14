{ fetchurl, stdenv, pkgconfig, nasm, fuse, wxGTK30, devicemapper, makeself,
  wxGUI ? true
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "veracrypt-${version}";
  version = "1.19";

  src = fetchurl {
    url = "https://launchpad.net/veracrypt/trunk/${version}/+download/VeraCrypt_${version}_Source.tar.gz";
    sha256 = "111xs1zmic82lpn5spn0ca33q0g4za04a2k4cvjwdb7k3vcicq6v";
  };

  # The source archive appears to be compressed twice ...
  unpackPhase =
    ''
      gzip -dc $src | tar xz
      cd Vera*/src
    '';

  nativeBuildInputs = [ makeself nasm pkgconfig ];
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
