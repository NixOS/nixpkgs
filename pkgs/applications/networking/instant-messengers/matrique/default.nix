{ stdenv, fetchFromGitLab, fetchFromGitHub, qmake
, qtquickcontrols2, qtmultimedia, qtgraphicaleffects
, libqmatrixclient
}:

let

  libqmatrixclient_git = libqmatrixclient.overrideDerivation (oldAttrs: {
    name = "libqmatrixclient-git-for-matrique";
    src = fetchFromGitHub {
      owner = "QMatrixClient";
      repo = "libqmatrixclient";
      rev = "d9ff200f";
      sha256 = "0qxkffg1499wnn8rbndq6z51sz6hiij2pkp40cvs530sl0zg0c69";
    };
  });

  SortFilterProxyModel = fetchFromGitLab {
    owner = "b0";
    repo = "SortFilterProxyModel";
    rev = "3c2c125c";
    sha256 = "1494dvq7kiq0ymf5f9hr47pw80zv3m3dncnaw1pnzs7mhkf2s5fr";
  };

in stdenv.mkDerivation rec {
  name = "matrique-${version}";
  version = "250";

  src = fetchFromGitLab {
    owner = "b0";
    repo = "matrique";
    rev = version;
    sha256 = "0l7ag2q3l8ixczwc43igvkkl81g5s5j032gzizmgpzb1bjpdgry7";
  };

  postPatch = ''
    rm -r include/*
    ln -sf ${libqmatrixclient_git.src} include/libqmatrixclient
    ln -sf ${SortFilterProxyModel} include/SortFilterProxyModel
  '';

  nativeBuildInputs = [ qmake ];
  buildInputs = [
    qtquickcontrols2 qtmultimedia qtgraphicaleffects
    libqmatrixclient_git
  ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "A glossy client for Matrix";
    maintainers = with maintainers; [ fpletz ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
