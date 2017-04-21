{ stdenv, buildGoPackage, fetchFromGitHub, fetchgx }:

buildGoPackage rec {
  name = "madonctl-${version}";
  version = "0.1.0";
  rev = "8d14d4d0847fe200d11c0b3f7a6252da5e687078";

  goPackagePath = "github.com/McKael/madonctl";

  src = fetchFromGitHub {
    inherit rev;
    owner = "McKael";
    repo = "madonctl";
    sha256 = "1nd07frifkw21av9lczm12ffky10ycv9ya501mihm82c78jk1sn5";
  };

  meta = with stdenv.lib; {
    description = "CLI for the Mastodon social network API";
    homepage = https://github.com/McKael/madonctl;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
