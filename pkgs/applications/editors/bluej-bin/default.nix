{ stdenv, fetchurl, makeWrapper, unzip, jetbrains
}:
let
  version = "414";
in
stdenv.mkDerivation {
  name = "bluej-bin-${version}";
  src = fetchurl {
    url = "https://www.bluej.org/download/files/BlueJ-linux-${version}.deb";
    sha512 = "c9c5c905d6dcf4388fe1423179be836ad8d35a4d197e53706a5764d9192c439aa60b80a28b87222b9f16ed1534d7a7768d924fc06ddd95107aea3cb00570c22a";
  };

  buildCommand = ''
    # Unpack the original deb package and perform some path patching.
    ar p $src data.tar.xz | tar xJ
    patchShebangs .

    # Copy to installation directory and create a wrapper capable of starting
    # it.
    mkdir -pv $out/
    mv usr/* $out
    cp -a usr $out
    makeWrapper ${jetbrains.jdk}/bin/java $out/bin/bluej \
      --add-flags "-Djavafx.embed.singleThread=true -Dawt.useSystemAAFontSettings=on -Xmx512M -cp \"$out/share/bluej/bluej.jar:${jetbrains.jdk}/lib/tools.jar\" bluej.Boot"
  '';

  buildInputs = [ makeWrapper unzip ];

  meta = {
    description = "A simple integrated development environment for Java";
    homepage = "https://www.bluej.org/";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ hochi ];
    platforms = stdenv.lib.platforms.unix;
  };
}
