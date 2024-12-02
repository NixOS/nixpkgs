{ lib, stdenv, fetchFromGitHub
, python3
, popt
}:

stdenv.mkDerivation rec {
  pname = "isomd5sum";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "rhinstaller";
    repo = pname;
    rev = version;
    sha256 = "sha256-c/4CQtAzatfG1Z3SfyB2OZmfJRMnyrZZTqSApsK7R+Q=";
  };

  strictDeps = true;
  nativeBuildInputs = [ python3 ];
  buildInputs = [ popt ] ;

  postPatch = ''
    substituteInPlace Makefile --replace "#/usr/" "#"
    substituteInPlace Makefile --replace "/usr/" "/"
  '';

  dontConfigure = true;

  makeFlags = [ "DESTDIR=${placeholder "out"}" ];

  # we don't install python stuff as it borks up directories
  installTargets = [ "install-bin" "install-devel" ];

  meta = with lib; {
    homepage = "https://github.com/rhinstaller/isomd5sum";
    description = "Utilities for working with md5sum implanted in ISO images";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ knl ];
  };
}
