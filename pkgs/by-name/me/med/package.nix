{ stdenv, lib, qt6, fetchFromGitHub, cmake, pkg-config, jsoncpp, readline }:

stdenv.mkDerivation rec {
  pname = "med";
  version = "3.10.1";

  src = fetchFromGitHub {
    owner = "allencch";
    repo = "med";
    rev = version;
    sha256 = "sha256-m2lVRSNaklB0Xfqgtyc0lNWXfTD8wTWsE06eGv4FOBE=";
  };

  nativeBuildInputs = [ qt6.wrapQtAppsHook cmake pkg-config ];
  buildInputs = [ qt6.qtbase qt6.qttools qt6.qtwayland jsoncpp readline ];

  postPatch = ''
    find . -type f -exec sed -i "s|/opt/med|$out/share/med|g" {} +
  '';

  meta = with lib; {
    description = "GUI game memory scanner and editor";
    homepage = "https://github.com/allencch/med";
    changelog = "https://github.com/allencch/med/releases/tag/${version}";
    maintainers = with maintainers; [ zebreus ];
    platforms = platforms.linux;
    license = licenses.bsd3;
    mainProgram = "med";
  };
}
