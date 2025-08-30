{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  meson,
  ninja,
  pkg-config,
  glib,
}:

stdenv.mkDerivation rec {
  pname = "libslirp";
  version = "4.9.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "slirp";
    repo = "libslirp";
    rev = "v${version}";
    sha256 = "sha256-MKP3iBExaPQryiahI1l/4bTgVht5Vu8AxaDyMotqmMo=";
  };

  patches = [
    # honor dns resolver port number on macos
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/slirp/libslirp/-/commit/baa4160b26431448b503d8d897db24fa0eb1386b.patch";
      hash = "sha256-TJDr0qRaoT0MjMcayG8j7jXlFN63BEl1L9/q+MnSWXs=";
    })
  ];

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
