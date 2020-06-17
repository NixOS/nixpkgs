{ stdenv, makeWrapper, fetchFromGitHub, cmake, alsaLib, mesa_glu, libXcursor, libXinerama, libXrandr, xorgserver }:

stdenv.mkDerivation rec {
  pname = "bonzomatic";
  version = "2018-03-29";

  src = fetchFromGitHub {
    owner = "Gargaj";
    repo = pname;
    rev = version;
    sha256 = "12mdfjvbhdqz1585772rj4cap8m4ijfci6ib62jysxjf747k41fg";
  };

  buildInputs = [ cmake makeWrapper alsaLib mesa_glu libXcursor libXinerama libXrandr xorgserver ];

  postFixup = ''
    wrapProgram $out/bin/Bonzomatic --prefix LD_LIBRARY_PATH : "${alsaLib}/lib"
  '';

  meta = with stdenv.lib; {
    description = "A live-coding tool for writing 2D fragment/pixel shaders";
    license = with licenses; [
      unlicense
      unfreeRedistributable # contains libbass.so in repository
    ];
    maintainers = [ maintainers.nocent ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
