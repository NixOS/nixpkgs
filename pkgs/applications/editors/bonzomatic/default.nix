{ lib, stdenv, fetchFromGitHub
, cmake, makeWrapper
, alsa-lib, fontconfig, mesa_glu, libXcursor, libXinerama, libXrandr, xorg
}:

stdenv.mkDerivation rec {
  pname = "bonzomatic";
<<<<<<< HEAD
  version = "2023-06-15";
=======
  version = "2022-08-20";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Gargaj";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-hwK3C+p1hRwnuY2/vBrA0QsJGIcJatqq+U5/hzVCXEg=";
=======
    sha256 = "sha256-AaUMefxQd00O+MAH4OLoyQIXZCRQQbt2ucgt7pVvN24=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = [
    alsa-lib fontconfig mesa_glu
    libXcursor libXinerama libXrandr xorg.xinput xorg.libXi xorg.libXext
  ];

  postFixup = ''
    wrapProgram $out/bin/bonzomatic --prefix LD_LIBRARY_PATH : "${alsa-lib}/lib"
  '';

  meta = with lib; {
    description = "Live shader coding tool and Shader Showdown workhorse";
    homepage = "https://github.com/gargaj/bonzomatic";
    license = licenses.unlicense;
    maintainers = [ maintainers.ilian ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
