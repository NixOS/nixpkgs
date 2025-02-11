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

stdenv.mkDerivation rec {
  pname = "slirp4netns";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "rootless-containers";
    repo = "slirp4netns";
    rev = "v${version}";
    sha256 = "sha256-1OiomraQ4wfrBPihGrf9sq8hPJUB45gvf7Y5j7iN8/E=";
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

  meta = with lib; {
    homepage = "https://github.com/rootless-containers/slirp4netns";
    description = "User-mode networking for unprivileged network namespaces";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ orivej ] ++ teams.podman.members;
    platforms = platforms.linux;
    mainProgram = "slirp4netns";
  };
}
