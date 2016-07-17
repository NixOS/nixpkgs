{ stdenv, requireFile, p7zip, SDL, openalSoft }:

let
  deps = stdenv.lib.makeLibraryPath [ SDL openalSoft ];

in stdenv.mkDerivation {
  name = "BinkPlayer";

  src = requireFile {
    url = "http://www.radgametools.com/down/Bink/BinkLinuxPlayer.7z";
    name = "BinkLinuxPlayer.7z";
    sha256 = "04pa2bad81hw5nx6a5zh6ab0rmcdwfqh3ifh5n7fbly90hm9vfwh";
  };

  buildCommand = ''
    mkdir -p $out/bin
    cd $out/bin
    7z x $src
    chmod +x BinkPlayer
    patchelf \
      --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) \
      --set-rpath ${deps} \
      BinkPlayer
  '';

  nativeBuildInputs = [ p7zip ];

  meta = with stdenv.lib; {
    description = "Play Bink files (or compiled Bink EXE files) from the command line";
    homepage = "http://www.radgametools.com/bnkmain.htm";
    license = licenses.unfree;
    platforms = [ "i686-linux" ];
    maintainers = with maintainers; [ abbradar ];
  };
}
