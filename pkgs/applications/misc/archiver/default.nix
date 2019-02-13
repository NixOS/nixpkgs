{ buildGoPackage
, fetchFromGitHub
, lib
}:

buildGoPackage rec {
  name = "archiver-${version}";
  version = "3.0.0";

  goPackagePath = "github.com/mholt/archiver";

  src = fetchFromGitHub {
    owner = "mholt";
    repo = "archiver";
    rev = "v${version}";
    sha256 = "1wngv51333h907mp6nbzd9dq6r0x06mag2cij92912jcbzy0q8bk";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "Easily create and extract .zip, .tar, .tar.gz, .tar.bz2, .tar.xz, .tar.lz4, .tar.sz, and .rar (extract-only) files with Go";
    homepage = https://github.com/mholt/archiver;
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.all;
  };
}
