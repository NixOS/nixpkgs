{ stdenv
, fetchFromGitHub
, pkg-config
, glib
, glibc
, systemd
}:

stdenv.mkDerivation rec {
  pname = "conmon";
  version = "2.0.15";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fshcmnfqzbagzcrh5nxw7pi0dd60xpq47a2lzfghklqhl1h0b5i";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib systemd ]
  ++ stdenv.lib.optionals (!stdenv.hostPlatform.isMusl) [ glibc glibc.static ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/containers/conmon";
    description = "An OCI container runtime monitor";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
