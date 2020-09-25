{ stdenv, fetchFromGitHub, cmake, python3 }:

stdenv.mkDerivation rec {
  pname = "timewarrior";
  version = "1.4.2";

  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "GothenburgBitFactory";
    repo = "timewarrior";
    rev = "v${version}";
    sha256 = "0qvhpva0hmhybn0c2aajndw5vnxar1jw4pjjajd2k2cr6vax29dw";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ python3 ];
  postInstall = ''
    for x in $out/share/doc/timew/ext/*; do
      chmod +x "$x"
    done
  '';
  patchPhase = ''
    patchShebangs .
  '';

  meta = with stdenv.lib; {
    description = "A command-line time tracker";
    homepage = "https://timewarrior.net";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer mrVanDalo ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
