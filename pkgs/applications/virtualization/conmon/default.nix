{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, glib
, glibc
, systemd
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "conmon";
  version = "2.0.26";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-q2lh02iZ7FDBPjtoKY5p3c6Vcn9Ey8DCMn/Oe7/74ug=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib systemd ]
  ++ lib.optionals (!stdenv.hostPlatform.isMusl) [ glibc glibc.static ];

  # manpage requires building the vendored go-md2man
  makeFlags = [ "bin/conmon" ];

  installPhase = ''
    install -D bin/conmon -t $out/bin
  '';

  passthru.tests = { inherit (nixosTests) cri-o podman; };

  meta = with lib; {
    homepage = "https://github.com/containers/conmon";
    description = "An OCI container runtime monitor";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
