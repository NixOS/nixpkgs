{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libslirp";
  version = "4.9.6";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "slirp";
    repo = "libslirp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nfR5eQrcpbkmn2tx/8l649NVPOsIFSFSBkW/vw0meCM=";
  };

  __structuredAttrs = true;
  strictDeps = true;
  separateDebugInfo = true;
  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [ glib ];

  postPatch = ''
    echo ${finalAttrs.version} > .tarball-version
  '';

  meta = {
    changelog = "https://gitlab.freedesktop.org/slirp/libslirp/-/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "General purpose TCP-IP emulator";
    homepage = "https://gitlab.freedesktop.org/slirp/libslirp";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    teams = [ lib.teams.freedesktop ];
  };
})
