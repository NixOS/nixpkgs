{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  glib,
}:

stdenv.mkDerivation rec {
  pname = "libslirp";
  version = "4.8.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "slirp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-t2LpOPx+S2iABQv3+xFdHj/FjWns40cNKToDKMZhAuw=";
  };

  separateDebugInfo = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [ glib ];

  postPatch = ''
    echo ${version} > .tarball-version
  '';

  meta = {
    description = "General purpose TCP-IP emulator";
    homepage = "https://gitlab.freedesktop.org/slirp/libslirp";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ orivej ];
    platforms = lib.platforms.unix;
  };
}
