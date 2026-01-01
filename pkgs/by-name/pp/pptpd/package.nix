{
  lib,
  stdenv,
  fetchurl,
  ppp,
}:

stdenv.mkDerivation rec {
  pname = "pptpd";
  version = "1.5.0";

  src = fetchurl {
    url = "mirror://sourceforge/poptop/${pname}/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-anJChLHOAOoj99dgjQgYQ6EMio2H2VHLLqhucKobTnc=";
  };

  buildInputs = [ ppp ];

  postPatch = ''
    substituteInPlace plugins/Makefile --replace-fail "install -o root" "install"
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://poptop.sourceforge.net/dox/";
    description = "PPTP Server for Linux";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ obadz ];
    license = lib.licenses.gpl2Only;
=======
  meta = with lib; {
    homepage = "https://poptop.sourceforge.net/dox/";
    description = "PPTP Server for Linux";
    platforms = platforms.linux;
    maintainers = with maintainers; [ obadz ];
    license = licenses.gpl2Only;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
