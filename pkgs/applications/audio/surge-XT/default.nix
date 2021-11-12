{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, cairo, libxkbcommon, xcbutilcursor, xcbutilkeysyms, xcbutil, libXrandr, libXinerama, libXcursor, alsa-lib, libjack2
}:

stdenv.mkDerivation rec {
  pname = "surge-XT";
  version = "unstable-2021-11-07";

  src = fetchFromGitHub {
    owner = "surge-synthesizer";
    repo = "surge";
    rev = "ed93833eb44b177c977e3a7b878ffdd9bf9f24e5";
    sha256 = "0b164659ksl6h5nn7jja5zccx2mwzibqs6b7hg8l98gpcy9fi5r2";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ cairo libxkbcommon xcbutilcursor xcbutilkeysyms xcbutil libXrandr libXinerama libXcursor alsa-lib libjack2 ];

  installPhase = ''
    cd ..
    cmake --build build --config Release --target install
  '';

  doInstallCheck = false;

  meta = with lib; {
    description = "LV2 & VST3 synthesizer plug-in (previously released as Vember Audio Surge)";
    homepage = "https://surge-synthesizer.github.io";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ magnetophon orivej ];
  };
}
