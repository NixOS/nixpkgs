{ stdenv, lib, fetchFromGitHub, pkg-config, cmake, libeb, lzo
, qtmultimedia, qttools, qtwebengine, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "qolibri";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "ludios";
    repo = "qolibri";
    rev = version;
    sha256 = "jyLF1MKDVH0Lt8lw+O93b+LQ4J+s42O3hebthJk83hg=";
  };

  nativeBuildInputs = [ pkg-config cmake qttools wrapQtAppsHook ];
  buildInputs = [
    libeb lzo qtmultimedia qtwebengine
  ];

  postInstall = ''
    install -D $src/qolibri.desktop -t $out/share/applications
  '';

  meta = with lib; {
    homepage = "https://github.com/ludios/qolibri";
    description = "EPWING reader for viewing Japanese dictionaries";
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
    license = licenses.gpl2;
  };
}
