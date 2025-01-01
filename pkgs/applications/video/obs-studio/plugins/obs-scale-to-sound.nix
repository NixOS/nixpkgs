{ lib
, stdenv
, fetchFromGitHub
, cmake
, obs-studio
}:

stdenv.mkDerivation rec {
  pname = "obs-scale-to-sound";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "dimtpap";
    repo = "obs-scale-to-sound";
    rev = version;
    sha256 = "sha256-q/zNHPazNwmd7GHXrxNgajtOhcW+oTgH9rkIBzJpdpA=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio ];

  cmakeFlags = [
    "-DBUILD_OUT_OF_TREE=On"
  ];

  postInstall = ''
    mkdir $out/lib $out/share
    mv $out/obs-plugins/64bit $out/lib/obs-plugins
    rm -rf $out/obs-plugins
    mv $out/data $out/share/obs
  '';

  meta = with lib; {
    description = "OBS filter plugin that scales a source reactively to sound levels";
    homepage = "https://github.com/dimtpap/obs-scale-to-sound";
    maintainers = with maintainers; [ flexiondotorg ];
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
