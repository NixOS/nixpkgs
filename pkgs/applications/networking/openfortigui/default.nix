{ stdenv
, lib
, git
, libsForQt5
, fetchgit
}:

stdenv.mkDerivation rec {
    pname = "openfortigui";
    version = "0.9.8-1";

    src = fetchgit {
        url = "https://github.com/theinvisible/openfortigui.git";
        rev = "v${version}";
        sha256 = "sha256-Lbc/SKrGx2DbIfhtqWnS81RVc1EMz8NnYEvULuL9J50=";
        fetchSubmodules = true;
        leaveDotGit = true;
    };

    nativeBuildInputs = [
        libsForQt5.wrapQtAppsHook
        git
    ];
    buildInputs = [
        libsForQt5.qtbase
        libsForQt5.qtkeychain
    ];

    preConfigure = ''
        cd openfortigui
        git submodule init
        git submodule update
    '';

    buildPhase = ''
        qmake
        make -j4
    '';

    installPhase = ''
        mkdir -p $out/bin
        mv openfortigui $out/bin
    '';

    meta = with lib; {
        description = "VPN-GUI to connect to Fortigate-Hardware, based on openfortivpn";
        homepage = "https://github.com/theinvisible/openfortigui";
        license = licenses.gpl3;
        maintainers = with maintainers; [ jrrmyr ];
        platforms = platforms.linux;
    };
}
