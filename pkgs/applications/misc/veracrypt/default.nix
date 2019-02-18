{ stdenv, fetchurl, pkgconfig, makeself, yasm, fuse, wxGTK, lvm2 }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "veracrypt";
  name = "${pname}-${version}";
  version = "1.23";

  src = fetchurl {
    url = "https://launchpad.net/${pname}/trunk/${version}/+download/VeraCrypt_${version}_Source.tar.bz2";
    sha256 = "009lqi43n2w272sxv7y7dz9sqx15qkx6lszkswr8mwmkpgkm0px1";
  };

  sourceRoot = "src";

  nativeBuildInputs = [ makeself pkgconfig yasm ];
  buildInputs = [ fuse lvm2 wxGTK ];

  enableParallelBuilding = true;

  installPhase = ''
    install -Dm 755 Main/${pname} "$out/bin/${pname}"
    install -Dm 444 Resources/Icons/VeraCrypt-256x256.xpm "$out/share/pixmaps/${pname}.xpm"
    install -Dm 444 License.txt -t "$out/share/doc/${pname}/"
    install -d $out/share/applications
    substitute Setup/Linux/${pname}.desktop $out/share/applications/${pname}.desktop \
      --replace "Exec=/usr/bin/veracrypt" "Exec=$out/bin/veracrypt" \
      --replace "Icon=veracrypt" "Icon=veracrypt.xpm"
  '';

  meta = {
    description = "Free Open-Source filesystem on-the-fly encryption";
    homepage = https://www.veracrypt.fr/;
    license = [ licenses.asl20 /* or */ "TrueCrypt License version 3.0" ];
    maintainers = with maintainers; [ dsferruzza ];
    platforms = platforms.linux;
  };
}
