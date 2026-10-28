{
  stdenv,
  fetchFromGitHub,
  flock,
  gitUpdater,
  bashInteractive,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "enroot";
  version = "4.2.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "enroot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TMfzXmKrhdiUan3kemivlEQ6KqUNGOHtCZVZQP1AcB8=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail \
        'git submodule update' \
        'echo git submodule update'
  ''
  # GCC >= 16 implicitly links `-latomic_asneeded`, which does not exist in the musl sysroot
  + lib.optionalString (stdenv.cc.isGNU && (lib.versionAtLeast stdenv.cc.version "16")) ''
    substituteInPlace Makefile \
      --replace-fail \
        '$(UTILS): LDFLAGS     += -pie -static-pie' \
        '$(UTILS): LDFLAGS     += -pie -static-pie -fno-link-libatomic'
  '';

  makeTarget = "install";
  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "prefix=/"
  ];

  nativeBuildInputs = [
    flock
  ];

  buildInputs = [
    bashInteractive
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Simple yet powerful tool to turn traditional container/OS images into unprivileged sandboxes";
    license = lib.licenses.asl20;
    homepage = "https://github.com/NVIDIA/enroot";
    changelog = "https://github.com/NVIDIA/enroot/releases/tag/v${finalAttrs.version}";
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "enroot";
  };
})
