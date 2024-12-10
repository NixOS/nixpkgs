{
  trivialBuild,
  lib,
  fetchurl,
}:

trivialBuild rec {
  pname = "pod-mode";
  version = "1.04";

  src = fetchurl {
    url = "mirror://cpan/authors/id/F/FL/FLORA/pod-mode-${version}.tar.gz";
    sha256 = "1wr0khymkaa65blrc5nya607c1a3sjsww49bbf8f0a6176as71sv";
  };

  meta = with lib; {
    description = "Major mode for editing .pod-files";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.all;
  };
}
