{ lib, stdenv, fetchFromGitHub, git, perl }:

stdenv.mkDerivation rec {
  pname = "topgit";
  version = "0.19.12";

  src = fetchFromGitHub {
    owner = "mackyle";
    repo = "topgit";
    rev = "${pname}-${version}";
    sha256 = "1wvf8hmwwl7a2fr17cfs3pbxjccdsjw9ngzivxlgja0gvfz4hjd5";
  };

  makeFlags = [ "prefix=${placeholder "out"}" ];

  nativeBuildInputs = [ perl git ];

  postInstall = ''
    install -Dm644 README -t "$out/share/doc/${pname}-${version}/"
    install -Dm755 contrib/tg-completion.bash -t "$out/share/bash-completion/completions/"
  '';

  meta = with lib; {
    description = "TopGit manages large amount of interdependent topic branches";
    homepage = "https://github.com/mackyle/topgit";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ marcweber ];
  };
}
