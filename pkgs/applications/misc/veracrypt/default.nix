{ stdenv, fetchurl, pkgconfig, makeself, yasm, fuse, unzip, wxGTK, lvm2 }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "veracrypt";
  version = "1.23";
  minorVersion = "-Hotfix-2";

  src = fetchurl {
    url = "https://launchpad.net/${pname}/trunk/${version}/+download/VeraCrypt_${version}${minorVersion}_Source.zip";
    sha256 = "229de81b2478cfa5fa73e74e60798a298cd616e9852b9f47b484c80bc2a2c259";
  };

  sourceRoot = "src";

  nativeBuildInputs = [ makeself pkgconfig yasm ];
  buildInputs = [ fuse lvm2 unzip wxGTK ];

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
