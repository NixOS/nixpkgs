{ stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "vul";
  version = "unstable-2020-02-15";

  src = fetchFromGitHub {
    owner = "LukeSmithxyz";
    repo = pname;
    rev = "f6ebd8f6b6fb8a111e7b59470d6748fcbe71c559";
    sha256 = "09rq51g1cbss3llzcij37f3zjf5kqf139hzl2ajfa65crmzphjb9";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with stdenv.lib; {
    description = "Latin Vulgate Bible on the Command Line";
    homepage = "https://github.com/LukeSmithxyz/vul";
    license = licenses.publicDomain;
    maintainers = [ maintainers.jtobin ];
  };
}

