{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  glib,
  glibc,
  libseccomp,
  systemd,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "conmon";
  version = "2.1.13";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "conmon";
    rev = "v${version}";
    hash = "sha256-XsVWcJsUc0Fkn7qGRJDG5xrQAsJr6KN7zMy3AtPuMTo=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    glib
    libseccomp
    systemd
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isMusl) [
    glibc
    glibc.static
  ];

  # manpage requires building the vendored go-md2man
  makeFlags = [
    "bin/conmon"
    "VERSION=${version}"
  ];

  installPhase = ''
    runHook preInstall
    install -D bin/conmon -t $out/bin
    runHook postInstall
  '';

  enableParallelBuilding = true;
  strictDeps = true;

  passthru.tests = { inherit (nixosTests) cri-o podman; };

  meta = {
    changelog = "https://github.com/containers/conmon/releases/tag/${src.rev}";
    homepage = "https://github.com/containers/conmon";
    description = "OCI container runtime monitor";
    license = lib.licenses.asl20;
    teams = [ lib.teams.podman ];
    platforms = lib.platforms.linux;
    mainProgram = "conmon";
  };
}
