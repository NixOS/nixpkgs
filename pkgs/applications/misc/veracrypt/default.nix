{ lib
, stdenv
, fetchurl
, pkg-config
, makeself
, yasm
, fuse
, wxGTK
, lvm2
}:

with lib;

stdenv.mkDerivation rec {
  pname = "veracrypt";
  version = "1.24-Update7";

  src = fetchurl {
    url = "https://launchpad.net/${pname}/trunk/${toLower version}/+download/VeraCrypt_${version}_Source.tar.bz2";
    sha256 = "0i7h44zn2mjzgh416l7kfs0dk6qc7b1bxsaxqqqcvgrpl453n7bc";
  };

  sourceRoot = "src";

  nativeBuildInputs = [ makeself pkg-config yasm ];
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
    homepage = "https://www.veracrypt.fr/";
    license = with licenses; [ asl20 /* and */ unfree /* TrueCrypt License version 3.0 */ ];
    maintainers = with maintainers; [ dsferruzza ];
    platforms = platforms.linux;
  };
}
