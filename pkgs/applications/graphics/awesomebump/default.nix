{ lib, stdenv, fetchurl, qtbase, qmakeHook, makeWrapper }:

stdenv.mkDerivation {
  name = "awesomebump-4.0";

  src = fetchurl {
    url = https://github.com/kmkolasinski/AwesomeBump/archive/Linuxv4.0.tar.gz;
    sha256 = "1rp4m4y2ld49hibzwqwy214cbiin80i882d9l0y1znknkdcclxf2";
  };

  setSourceRoot = "sourceRoot=$(echo */Sources)";

  buildInputs = [ qtbase qmakeHook makeWrapper ];

  enableParallelBuilding = true;

  # Before we do various fixups, remove qt tree---this means the
  # standard RPATH shrinking code will remove the references.  Should
  # be obsoleted when NixOS/patchelf#98 is released.
  preFixup = ''
    rm -rf $(pwd)/../../__nix_qt5__
  '';

  installPhase =
    ''
      d=$out/libexec/AwesomeBump
      mkdir -p $d $out/bin
      cp AwesomeBump $d/
      cp -prd ../Bin/Configs ../Bin/Core $d/

      # AwesomeBump expects to find Core and Configs in its current
      # directory.
      makeWrapper $d/AwesomeBump $out/bin/AwesomeBump \
        --run "cd $d"
    '';

  meta = {
    homepage = https://github.com/kmkolasinski/AwesomeBump;
    description = "A program to generate normal, height, specular or ambient occlusion textures from a single image";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.eelco ];
    platforms = lib.platforms.linux;
  };
}
