{ stdenv, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "ghq";
  version = "0.12.6";

  src = fetchFromGitHub {
    owner = "motemen";
    repo = "ghq";
    rev = "v${version}";
    sha256 = "14rm7fvphr7r9x0ys10vhzjwhfhhscgr574n1i1z4lzw551lrnp4";
  };

  modSha256 = "1y2v8ir7kc2avgri06nagfyaxqr3xrg4g5pxl9rwzq9dyzm6ci5z";

  buildFlagsArray = ''
    -ldflags=
      -X=main.Version=${version}
  '';

  postInstall = ''
    install -m 444 -D ${src}/zsh/_ghq $out/share/zsh/site-functions/_ghq
  '';

  patches = [
    (fetchpatch {
      # remove once the commit lands in a release.
      url = "https://github.com/motemen/ghq/commit/38ac89e60e60182b5870108f9753c9fe8d00e4a6.patch";
      sha256 = "1z8yvzmka3sh44my6jnwc39p8zs7mczxgvwc9z0pkqk4vgvaj8gj";
    })
  ];

  meta = {
    description = "Remote repository management made easy";
    homepage = https://github.com/motemen/ghq;
    maintainers = with stdenv.lib.maintainers; [ sigma ];
    license = stdenv.lib.licenses.mit;
  };
}
