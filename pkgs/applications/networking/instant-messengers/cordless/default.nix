{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cordless";
  version = "2020-11-22";

  src = fetchFromGitHub {
    owner = "Bios-Marcel";
    repo = pname;
    rev = version;
    sha256 = "0avf09b73fs3wpb4fzmm6ka595aanfvp95m6xj1ccxvq8ciwpqcw";
  };

  subPackages = [ "." ];

  vendorSha256 = "01anbhwgwam70dymcmvkia1xpw48658rq7wv4m7fiavxvnli6z2y";

  meta = with lib; {
    homepage = "https://github.com/Bios-Marcel/cordless";
    description = "Discord terminal client";
    license = licenses.bsd3;
    maintainers = with maintainers; [ colemickens ];
  };
}
