{ stdenv, fetchurl, rpmextract, patchelf, bash }:

stdenv.mkDerivation rec {
  pname = "scaleft";
  version = "1.45.3";

  src =
    fetchurl {
      url = "http://pkg.scaleft.com/rpm/scaleft-client-tools-${version}-1.x86_64.rpm";
      sha256 = "02hsn64kg22pgga5ldjwhnqc6jq8w03mwf40dfanln1qz38x9nx1";
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
