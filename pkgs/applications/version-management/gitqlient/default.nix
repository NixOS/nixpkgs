{ lib
, mkDerivation
, fetchFromGitHub
, qmake
, qtwebengine
, gitUpdater
}:

mkDerivation rec {
  pname = "gitqlient";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "francescmm";
    repo = pname;
    rev = "v${version}";
    sha256 = "018jz6b28zwr205jmgw13ddlfvlhxqf0cw1pfjiwsi6i8gay7w6s";
  };

  nativeBuildInputs = [
    qmake
  ];

  buildInputs = [
    qtwebengine
  ];

  qmakeFlags = [
    "GitQlient.pro"
  ];

  passthru.updateScript = gitUpdater { inherit pname version; };

  meta = with lib; {
    homepage = "https://github.com/francescmm/GitQlient";
    description = "Multi-platform Git client written with Qt";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
