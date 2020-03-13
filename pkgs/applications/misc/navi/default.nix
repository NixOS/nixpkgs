{ rustPlatform, fetchFromGitHub, stdenv, fzf, makeWrapper, openssl, pkgconfig }:

rustPlatform.buildRustPackage rec {
  pname = "navi";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "denisidoro";
    repo = "navi";
    rev = "v${version}";
    sha256 = "1195f7c3ij2mkv0k1h9fwn6jkyjb01w0p6mj2xc39w5f6i0c0hwp";
  };

  cargoSha256 = "0ks25w0dncaiw3ma05r8jrng3cczancrynnpgdksbvgz49lg3wjw";

  postInstall = ''
    mkdir -p $out/share/navi/
    mv shell $out/share/navi/

    wrapProgram "$out/bin/navi" \
      --suffix "PATH" : "${fzf}/bin"
  '';
  buildInputs = [ openssl ];
  nativeBuildInputs = [ makeWrapper pkgconfig ];

  meta = with stdenv.lib; {
    description = "An interactive cheatsheet tool for the command-line";
    homepage = "https://github.com/denisidoro/navi";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ mrVanDalo ];
  };
}
