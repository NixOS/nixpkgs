{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  obs-studio,
}:

stdenv.mkDerivation rec {
  pname = "obs-source-switcher";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-source-switcher";
    rev = "8babf207d140e52114b6db63d98749d7a0a2758b";
    sha256 = "sha256-J/NdIGsSXCtSOGF72pJZqqN5Y73eJfrA72LgZcTlP5o=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio ];

  cmakeFlags = [
    "-DBUILD_OUT_OF_TREE=On"
  ];

  postInstall = ''
    rm -rf $out/obs-plugins $out/data
  '';

  meta = with lib; {
    description = "Plugin for OBS Studio to switch between a list of sources";
    homepage = "https://github.com/exeldro/obs-source-switcher";
    maintainers = with maintainers; [ flexiondotorg ];
    license = licenses.gpl2Plus;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
}
