{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, glib
, glibc
, libseccomp
, systemd
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "conmon";
  version = "2.0.30";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NZMuHhQyo+95QTJcR79cyZr86ytkbo4nmaqTF0Bdt+s=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib libseccomp systemd ]
  ++ lib.optionals (!stdenv.hostPlatform.isMusl) [ glibc glibc.static ];

  # manpage requires building the vendored go-md2man
  makeFlags = [ "bin/conmon" ];

  installPhase = ''
    runHook preInstall
    install -D bin/conmon -t $out/bin
    runHook postInstall
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
