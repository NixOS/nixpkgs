{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "vul";
  version = "unstable-2020-02-15";

  src = fetchFromGitHub {
    owner = "LukeSmithxyz";
    repo = pname;
    rev = "f6ebd8f6b6fb8a111e7b59470d6748fcbe71c559";
    sha256 = "aUl4f82sGOWkEvTDNILDszj5hztDRvYpHVovFl4oOCc=";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "Latin Vulgate Bible on the Command Line";
    homepage = "https://github.com/LukeSmithxyz/vul";
    license = licenses.publicDomain;
    maintainers = [ maintainers.j0hax ];
  };
}
