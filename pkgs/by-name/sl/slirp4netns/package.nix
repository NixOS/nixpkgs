{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  glib,
  libcap,
  libseccomp,
  libslirp,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "slirp4netns";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "rootless-containers";
    repo = "slirp4netns";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-dPhUr9GdujTpUsnfvZDp8eOBQwlzqwtwziII2QWD4JA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    glib
    libcap
    libseccomp
    libslirp
  ];

  enableParallelBuilding = true;
  strictDeps = true;

  passthru.tests = { inherit (nixosTests) podman; };

  meta = {
    homepage = "https://github.com/rootless-containers/slirp4netns";
    description = "User-mode networking for unprivileged network namespaces";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
    teams = [ lib.teams.podman ];
    platforms = lib.platforms.linux;
    mainProgram = "slirp4netns";
  };
})
