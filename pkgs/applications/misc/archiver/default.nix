{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "archiver";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "mholt";
    repo = pname;
    rev = "v${version}";
    sha256 = "1yr2jhidqvbwh1y08lpqaidwpr5yx3bhvznm5fc9pk64s7z5kq3h";
  };

  vendorSha256 = "1ikrgl03r9zkn86kxkqi2kf540g3qzzz24i5wvh6g3d5q49nygl9";

  meta = with lib; {
    description = "Easily create & extract archives, and compress & decompress files of various formats";
    homepage = "https://github.com/mholt/archiver";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.all;
  };
}
