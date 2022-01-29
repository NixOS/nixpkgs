{ lib, mkDerivation, fetchFromGitLab
, cmake, pkg-config
, alsa-lib, pipewire
}:

mkDerivation rec {
  pname = "qpwgraph";
  version = "0.2.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "rncbc";
    repo = "qpwgraph";
    rev = "v${version}";
    sha256 = "sha256-SGx80fMFomNEa/jgH8Yeof+f7zXCDxx3Yqd0GxHZGMw=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ alsa-lib pipewire ];

  meta = with lib; {
    description = "Qt graph manager for PipeWire, similar to QjackCtl.";
    longDescription = ''
      qpwgraph is a graph manager dedicated for PipeWire,
      using the Qt C++ framework, based and pretty much like
      the same of QjackCtl.
    '';
    homepage = "https://gitlab.freedesktop.org/rncbc/qpwgraph";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kanashimia ];
  };
}
