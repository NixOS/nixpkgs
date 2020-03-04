{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "git-my";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "davidosomething";
    repo = "git-my";
    rev = version;
    sha256 = "0jji5zw25jygj7g4f6f3k0p0s9g37r8iad8pa0s67cxbq2v4sc0v";
  };

  dontBuild = true;

  installPhase = ''
    install -Dm755 -t "$out"/bin ./git-my
  '';

  meta = with stdenv.lib; {
    description =
      "List remote branches if they're merged and/or available locally";
    homepage = https://github.com/davidosomething/git-my;
    license = licenses.free;
    maintainers = with maintainers; [ bb010g ];
    platforms = platforms.all;
  };
}

