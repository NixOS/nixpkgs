{ buildGoPackage, lib, fetchFromGitHub }:

buildGoPackage rec {
  pname = "utahfs";
  version = "1.0";
  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = pname;
    rev = "v${version}";
    sha256 = "1hpwch5fsqlxwpk5afawa1k5s0bx5c1cw0hvdllp7257lgly19fb";
  };

  goPackagePath = "github.com/cloudflare/utahfs";

  meta = with lib; {
    homepage = "https://github.com/cloudflare/utahfs";
    description =
      "Encrypted storage system that provides a user-friendly FUSE drive backed by cloud storage";
    license = licenses.bsd3;
    maintainers = [ maintainers.snglth ];
    platforms = platforms.unix;
    # does not build with go 1.17: https://github.com/cloudflare/utahfs/issues/46
    broken = true;
  };
}
