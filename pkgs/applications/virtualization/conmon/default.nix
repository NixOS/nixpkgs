{ stdenv
, fetchFromGitHub
, pkg-config
, glib
, glibc
, systemd
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "conmon";
  version = "2.0.20";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "1f09wx5k98fa55r73y5v0sgf2lha675xhk40piyf0b7zqknl6lya";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib systemd ]
  ++ stdenv.lib.optionals (!stdenv.hostPlatform.isMusl) [ glibc glibc.static ];

  installFlags = [ "PREFIX=$(out)" ];

  passthru.tests.podman = nixosTests.podman;

  meta = with stdenv.lib; {
    homepage = "https://github.com/containers/conmon";
    description = "An OCI container runtime monitor";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
