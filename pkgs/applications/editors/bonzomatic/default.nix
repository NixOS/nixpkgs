{ lib, stdenv, fetchFromGitHub
, cmake, makeWrapper
, alsaLib, fontconfig, mesa_glu, libXcursor, libXinerama, libXrandr, xorg
}:

stdenv.mkDerivation rec {
  pname = "bonzomatic";
  version = "2021-03-07";

  src = fetchFromGitHub {
    owner = "Gargaj";
    repo = pname;
    rev = version;
    sha256 = "0gbh7kj7irq2hyvlzjgbs9fcns9kamz7g5p6msv12iw75z9yi330";
  };

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = [
    alsaLib fontconfig mesa_glu
    libXcursor libXinerama libXrandr xorg.xinput xorg.libXi xorg.libXext
  ];

  postFixup = ''
    wrapProgram $out/bin/bonzomatic --prefix LD_LIBRARY_PATH : "${alsaLib}/lib"
  '';

  meta = with lib; {
    description = "Live shader coding tool and Shader Showdown workhorse";
    homepage = "https://github.com/gargaj/bonzomatic";
    license = licenses.unlicense;
    maintainers = [ maintainers.ilian ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
