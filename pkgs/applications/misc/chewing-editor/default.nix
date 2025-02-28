{
  lib,
  mkDerivation,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libchewing,
  qtbase,
  qttools,
}:

mkDerivation rec {
  pname = "chewing-editor";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "chewing";
    repo = pname;
    rev = version;
    sha256 = "0kc2hjx1gplm3s3p1r5sn0cyxw3k1q4gyv08q9r6rs4sg7xh2w7w";
  };

  doCheck = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    libchewing
    qtbase
    qttools
  ];

  meta = with lib; {
    description = "Cross platform chewing user phrase editor";
    mainProgram = "chewing-editor";
    longDescription = ''
      chewing-editor is a cross platform chewing user phrase editor. It provides a easy way to manage user phrase. With it, user can customize their user phrase to increase input performance.
    '';
    homepage = "https://github.com/chewing/chewing-editor";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.ShamrockLee ];
    platforms = platforms.all;
  };
}
