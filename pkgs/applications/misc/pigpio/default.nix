{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "pigpio";
  version = "79";

  src = fetchFromGitHub {
    owner = "joan2937";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wgcy9jvd659s66khrrp5qlhhy27464d1pildrknpdava19b1r37";
  };

  makeFlags = [ "prefix=$(out)" ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace '$(DESTDIR)/opt/pigpio/cgi' '$(DESTDIR)/$(prefix)/cgi' \
      --replace 'ldconfig' '# ldconfig'
  '';

  meta = with lib; {
    description = "Raspberry Pi GPIO module";
    homepage = "https://github.com/joan2937/pigpio";
    license = licenses.unlicense;
    platforms = with platforms; [ arm aarch64 ];
    maintainers = with maintainers; [ misuzu ];
  };
}
