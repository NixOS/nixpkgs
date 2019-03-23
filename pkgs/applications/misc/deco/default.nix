{ stdenv, fetchFromGitHub, scsh, feh, xorg }:

stdenv.mkDerivation rec {
  pname = "deco";
  version = "0.0.2";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "ebzzry";
    repo = pname;
    rev = "49cded5ad123b0169f47cd0dc0f5420f4b581837";
    sha256 = "19rvqhw0blwga8ck86yy8hj7j1l9hriphlld6yrfd3yip4jprjzz";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp ${pname} $out/bin
    chmod +x $out/bin/${pname}
  '';

  postFixup = ''
    substituteInPlace $out/bin/deco --replace "/usr/bin/env scsh" "${scsh}/bin/scsh"
    substituteInPlace $out/bin/deco --replace "feh" "${feh}/bin/feh"
    substituteInPlace $out/bin/deco --replace "xdpyinfo" "${xorg.xdpyinfo}/bin/xdpyinfo"
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
