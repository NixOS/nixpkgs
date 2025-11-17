{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  glib,
  glibc,
  libseccomp,
  systemdMinimal,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "conmon";
  version = "2.1.13";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "conmon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XsVWcJsUc0Fkn7qGRJDG5xrQAsJr6KN7zMy3AtPuMTo=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    glib
    libseccomp
    systemdMinimal
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isMusl) [
    glibc
    glibc.static
  ];

  # manpage requires building the vendored go-md2man
  makeFlags = [
    "bin/conmon"
    "VERSION=${finalAttrs.version}"
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
    changelog = "https://github.com/containers/conmon/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/containers/conmon";
    description = "OCI container runtime monitor";
    license = lib.licenses.asl20;
    teams = [ lib.teams.podman ];
    platforms = lib.platforms.linux;
    mainProgram = "conmon";
  };
})
