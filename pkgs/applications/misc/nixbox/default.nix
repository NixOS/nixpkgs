{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "nixbox";
  version = "unstable-2019-04-20";

  src = fetchFromGitHub {
    owner = "LinArcX";
    repo = pname;
    rev = "c9a202e59b635816708b49da370029f1412fa372";
    sha256 = "1glr0kz9r0bs3pzq8l76hpl6hwh47p65snvp4riqzxpcjxywgh86";
  };

  installPhase = ''
    mkdir -p $out/bin
    chmod +x nixbox
    cp nixbox $out/bin
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/LinArcX/nixbox;
    description = "A menu driven shell script to manage nixos operations";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.linarcx ];
  };
}
