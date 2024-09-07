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
  version = "2.1.12";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-iSC1Q7fdf+4YH4vLFPOscRWxNv/xygYx872u8msmMmc=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib libseccomp systemd ]
    ++ lib.optionals (!stdenv.hostPlatform.isMusl) [ glibc glibc.static ];

  # manpage requires building the vendored go-md2man
  makeFlags = [ "bin/conmon" "VERSION=${version}" ];

  installPhase = ''
    runHook preInstall
    install -D bin/conmon -t $out/bin
    runHook postInstall
  '';

  enableParallelBuilding = true;
  strictDeps = true;

  passthru.tests = { inherit (nixosTests) cri-o podman; };

  meta = with lib; {
    changelog = "https://github.com/containers/conmon/releases/tag/${src.rev}";
    homepage = "https://github.com/containers/conmon";
    description = "OCI container runtime monitor";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
    mainProgram = "conmon";
  };
}
