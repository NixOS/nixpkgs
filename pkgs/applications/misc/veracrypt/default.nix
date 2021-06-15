{ lib, stdenv, fetchurl, fetchpatch, pkg-config, makeself, yasm, fuse, wxGTK, lvm2 }:

with lib;

stdenv.mkDerivation rec {
  pname = "veracrypt";
  version = "1.24-Hotfix1";

  src = fetchurl {
    url = "https://launchpad.net/${pname}/trunk/${toLower version}/+download/VeraCrypt_${version}_Source.tar.bz2";
    sha256 = "8b40ece805b216843d7a71b1a30069c4057931341b030bf65caace59263c5c8c";
  };


  patches = [
    # https://github.com/veracrypt/VeraCrypt/issues/529 - fix build on non-x86
    (fetchpatch {
      url = "https://github.com/veracrypt/VeraCrypt/commit/afe6b2f45b15393026a1159e5f3d165ac7d0b94a.patch";
      sha256 = "1xm9cl6zinlr0vah5xr9bvh0y9gw4331zl7d2n5xvqrcdxw3ww1y";
      stripLen = 1;
    })
    # https://github.com/veracrypt/VeraCrypt/issues/529 - fix build on non-x86
    (fetchpatch {
      url = "https://github.com/veracrypt/VeraCrypt/commit/3fa636d477119fff6e372074568edb42d038f508.patch";
      sha256 = "0qsccilip0ksnlzxina38a052gb533r4s422lxhrj3wv9zgpp7l3";
      stripLen = 1;
    })
  ];

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
