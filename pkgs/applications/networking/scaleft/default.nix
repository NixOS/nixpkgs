{ stdenv, fetchurl, rpmextract, patchelf, bash }:

stdenv.mkDerivation rec {
  pname = "scaleft";
  version = "1.41.0";

  src =
    fetchurl {
      url = "http://pkg.scaleft.com/rpm/scaleft-client-tools-${version}-1.x86_64.rpm";
      sha256 = "a9a2f60cc85167a1098f44b35efd755b8155f0b88da8572e96ace767e7933c4d";
    };

  nativeBuildInputs = [ patchelf rpmextract ];

  libPath =
    stdenv.lib.makeLibraryPath
       [ stdenv.cc stdenv.cc.cc.lib ];

  buildCommand = ''
    mkdir -p $out/bin/
    cd $out
    rpmextract $src
    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      usr/bin/sft
    patchelf \
      --set-rpath ${libPath} \
      usr/bin/sft
    ln -s $out/usr/bin/sft $out/bin/sft
    chmod +x $out/bin/sft
    patchShebangs $out
  '';

  meta = with stdenv.lib; {
    description = "ScaleFT provides Zero Trust software which you can use to secure your internal servers and services";
    homepage = "https://www.scaleft.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ jloyet ];
    platforms = [ "x86_64-linux" ];
  };
}
