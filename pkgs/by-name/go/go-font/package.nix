{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation {
  pname = "go-font";
  version = "2.010";

  src = fetchzip {
    url = "https://go.googlesource.com/image/+archive/41969df76e82aeec85fa3821b1e24955ea993001/font/gofont/ttfs.tar.gz";
    stripRoot = false;
    hash = "sha256-rdzt51wY4b7HEr7W/0Ar/FB0zMyf+nKLsOT+CRSEP3o=";
  };

  nativeBuildInputs = [ installFonts ];

  postInstall = ''
    mkdir -p $out/share/doc/go-font
    cp $src/README $out/share/doc/go-font/LICENSE
  '';

  meta = {
    homepage = "https://blog.golang.org/go-fonts";
    description = "Go font family";
    changelog = "https://go.googlesource.com/image/+log/refs/heads/master/font/gofont";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sternenseemann ];
    platforms = lib.platforms.all;
  };
}
