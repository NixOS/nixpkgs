{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  obs-studio,
  qtbase,
}:

stdenv.mkDerivation rec {
  pname = "obs-shaderfilter";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-shaderfilter";
    rev = version;
    sha256 = "sha256-INxz8W4AMKxRcfpZkhqqsWWWQQVEc2G9iFQBit1YA2E=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    obs-studio
    qtbase
  ];

  cmakeFlags = [
    "-DBUILD_OUT_OF_TREE=On"
  ];

  dontWrapQtApps = true;

  postInstall = ''
    rm -rf $out/obs-plugins
    mv $out/data $out/share/obs
  '';

  meta = with lib; {
    description = "OBS Studio filter for applying an arbitrary shader to a source";
    homepage = "https://github.com/exeldro/obs-shaderfilter";
    maintainers = with maintainers; [ flexiondotorg ];
    license = licenses.gpl2Plus;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
}
