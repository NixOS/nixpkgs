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
  version = "4.9.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "slirp";
    repo = "libslirp";
    rev = "v${version}";
    sha256 = "sha256-Eqdw6epFkLv4Dnw/s1pcKW0P70ApZwx/J2VkCwn50Ew=";
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

  meta = with lib; {
    description = "General purpose TCP-IP emulator";
    homepage = "https://gitlab.freedesktop.org/slirp/libslirp";
    license = licenses.bsd3;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.unix;
  };
}
