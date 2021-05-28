{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cordless";
  version = "2020-08-30";

  src = fetchFromGitHub {
    owner = "Bios-Marcel";
    repo = pname;
    rev = version;
    sha256 = "sha256-CwOI7Ah4+sxD9We+Va5a6jYat5mjOeBk2EsOfwskz6k=";
  };

  subPackages = [ "." ];

  vendorSha256 = "sha256-01I7GrZkaskuz20kVK2YwqvP7ViPMlQ3BFaoLHwgvOE=";

  meta = with stdenv.lib; {
    homepage = "https://github.com/Bios-Marcel/cordless";
    description = "Discord terminal client";
    license = licenses.bsd3;
    maintainers = with maintainers; [ colemickens ];
    platforms = platforms.unix;
  };
}
