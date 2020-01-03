{ stdenv, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "umoci";
  version = "0.4.4";

  goPackagePath = "github.com/openSUSE/umoci";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "umoci";
    rev = "v${version}";
    sha256 = "1mmk9y6xk0qk5rgysmm7x16b025zzwa2sd13jd32drd48scai2dw";
  };

  meta = with stdenv.lib; {
    description = "umoci modifies Open Container images";
    homepage = https://umo.ci;
    license = licenses.asl20;
    maintainers = with maintainers; [ zokrezyl ];
    platforms = platforms.linux;
  };
}
