{ stdenv, fetchFromGitHub, fetchpatch, libiconv }:

stdenv.mkDerivation rec {
  pname = "mblaze";
  version = "0.5.1";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ libiconv ];

  src = fetchFromGitHub {
    owner = "chneukirchen";
    repo = "mblaze";
    rev = "v${version}";
    sha256 = "11x548dl2jy9cmgsakqrzfdq166whhk4ja7zkiaxrapkjmkf6pbh";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/leahneukirchen/mblaze/commit/53151f4f890f302291eb8d3375dec4f8ecb66ed7.patch";
      sha256 = "1mcyrh053iiyzdhgm09g5h3a77np496whnc7jr4agpk1nkbcpfxc";
    })
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    install -Dm644 -t $out/share/zsh/site-functions contrib/_mblaze
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/chneukirchen/mblaze;
    description = "Unix utilities to deal with Maildir";
    license = licenses.cc0;
    platforms = platforms.all;
    maintainers = [ maintainers.ajgrf ];
  };
}
