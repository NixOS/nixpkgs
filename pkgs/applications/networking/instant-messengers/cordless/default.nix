{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cordless";
  version = "2020-10-24";

  src = fetchFromGitHub {
    owner = "Bios-Marcel";
    repo = pname;
    rev = version;
    sha256 = "18j8yrnipiivc49jwbb0ipgqwdi249fs9zxxz8qx8jfq77imvwbq";
  };

  subPackages = [ "." ];

  vendorSha256 = "1h47aqf8bmyqvaayfj16br1402qzy7kf8rk96f3vnsyvsnkg5gw5";

  meta = with stdenv.lib; {
    homepage = "https://github.com/Bios-Marcel/cordless";
    description = "Discord terminal client";
    license = licenses.bsd3;
    maintainers = with maintainers; [ colemickens ];
    platforms = platforms.unix;
  };
}
