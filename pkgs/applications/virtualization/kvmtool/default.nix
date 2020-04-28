{ stdenv, fetchgit, dtc }:

stdenv.mkDerivation rec {
  pname = "kvmtool";
  version = "0.20200424";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/will/${pname}.git";
    rev = "c0c45eed4f3fb799764979dec5cfb399071d6916";
    sha256 = "0ir6aqvipss145r85324nw84k4ilzxa2rsa1wr5303p1h6gs0qkk";
  };

  makeFlags = [ "prefix=$(out)" ];

  buildInputs = [ dtc ];

  meta = with stdenv.lib; {
    description = "A lightweight tool for hosting KVM guests";
    homepage =
      "https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git/tree/README";
    license = licenses.gpl2;
    maintainers = [ maintainers.chkno ];
  };
}
