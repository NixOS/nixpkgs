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
  version = "4.9.3";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "slirp";
    repo = "libslirp";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Spr3dO5ehuUlzx3EnJi8najANWOirwQcTsWTVRVXYuY=";
  };

  separateDebugInfo = true;

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
    description = "General purpose TCP-IP emulator";
    homepage = "https://gitlab.freedesktop.org/slirp/libslirp";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
