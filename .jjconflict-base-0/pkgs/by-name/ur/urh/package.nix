{ stdenv, lib, fetchFromGitHub, python3Packages
, hackrf, rtl-sdr, airspy, limesuite, libiio
, libbladeRF
, qt5
, wrapGAppsHook3
, USRPSupport ? false, uhd }:

python3Packages.buildPythonApplication rec {
  pname = "urh";
  version = "2.9.6";

  src = fetchFromGitHub {
    owner = "jopohl";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-4Fe2+BUdnVdNQHqZeftXLabn/vTzgyynOtqy0rAb0Rk=";
  };

  nativeBuildInputs = [ qt5.wrapQtAppsHook wrapGAppsHook3 ];
  buildInputs = [ hackrf rtl-sdr airspy limesuite libiio libbladeRF ]
    ++ lib.optional USRPSupport uhd
    ++ lib.optional stdenv.hostPlatform.isLinux qt5.qtwayland;

  propagatedBuildInputs = with python3Packages; [
    pyqt5 numpy psutil cython pyzmq pyaudio setuptools
  ];

  postFixup = ''
    wrapQtApp $out/bin/urh
  '';

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/jopohl/urh";
    description = "Universal Radio Hacker: investigate wireless protocols like a boss";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
