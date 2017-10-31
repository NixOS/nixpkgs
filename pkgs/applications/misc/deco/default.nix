{ stdenv, fetchFromGitHub, scsh, feh, xlibs }:

stdenv.mkDerivation rec {
  pname = "deco";
  version = "0.0.1";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "ebzzry";
    repo = pname;
    rev = "037f473ae4bdce5d3e2f76891785f0f7479cca75";
    sha256 = "1fv15nc9zqbn3c51vnm50yidj5ivpi61zg55cs46x3gi2x79x43q";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp ${pname} $out/bin
    chmod +x $out/bin/${pname}
  '';

  postFixup = ''
    substituteInPlace $out/bin/deco --replace "/usr/bin/env scsh" "${scsh}/bin/scsh"
    substituteInPlace $out/bin/deco --replace "feh" "${feh}/bin/feh"
    substituteInPlace $out/bin/deco --replace "xdpyinfo" "${xlibs.xdpyinfo}/bin/xdpyinfo"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/ebzzry/deco;
    description = "A simple root image setter";
    license = licenses.mit;
    maintainers = [ maintainers.ebzzry ];
    platforms = platforms.unix;
  };

  dontBuild = true;
}
