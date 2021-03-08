{ lib, stdenv, fetchFromGitHub, pkg-config, gtk3 }:

stdenv.mkDerivation rec {
  pname = "xdragon";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "mwh";
    repo = "dragon";
    rev = "v${version}";
    sha256 = "0fgzz39007fdjwq72scp0qygp2v3zc5f1xkm0sxaa8zxm25g1bra";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk3 ];

  installFlags = [ "PREFIX=${placeholder "out"}/bin" ];
  postInstall = ''
    ln -s $out/bin/dragon $out/bin/xdragon
  '';

  meta = with lib; {
    description = "Simple drag-and-drop source/sink for X (called dragon in upstream)";
    homepage = "https://github.com/mwh/dragon";
    license = licenses.gpl3;
    maintainers = with maintainers; [ das_j ];
  };
}
