{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rmapi";
  version = "0.0.11";

  src = fetchFromGitHub {
    owner = "juruen";
    repo = "rmapi";
    rev = "v${version}";
    sha256 = "0zks1pcj2s2pqkmw0hhm41vgdhfgj2r6dmvpsagbmf64578ww349";
  };

  vendorSha256 = "077s13pcql5w2m6wzls1q06r7p501kazbwzxgfh6akwza15kb4is";

  meta = with stdenv.lib; {
    description = "A Go app that allows access to the ReMarkable Cloud API programmatically";
    homepage = "https://github.com/juruen/rmapi";
    changelog = "https://github.com/juruen/rmapi/blob/v${version}/CHANGELOG.md";
    license = licenses.agpl3;
    maintainers = [ maintainers.nickhu ];
    platforms = platforms.all;
  };
}
