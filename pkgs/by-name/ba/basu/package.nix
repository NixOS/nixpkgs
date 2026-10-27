{
  lib,
  stdenv,
  fetchFromSourcehut,
  audit,
  pkg-config,
  libcap,
  gperf,
  meson,
  ninja,
  python3,
  getent,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "basu";
  version = "0.2.1";

  src = fetchFromSourcehut {
    owner = "~emersion";
    repo = "basu";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zIaEIIo8lJeas2gVjMezO2hr8RnMIT7iiCBilZx5lRQ=";
  };

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    audit
    libcap
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    python3
    getent
    gperf
  ];

  mesonFlags = lib.optionals (!stdenv.hostPlatform.isLinux) [
    "-Daudit=disabled"
    "-Dlibcap=disabled"
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.useLLVM {
    NIX_LDFLAGS = "--undefined-version";
  };

  preConfigure = ''
    pushd src/basic
    patchShebangs \
      generate-cap-list.sh generate-errno-list.sh generate-gperfs.py
    popd
  '';

  meta = {
    homepage = "https://sr.ht/~emersion/basu";
    description = "Sd-bus library, extracted from systemd";
    mainProgram = "basuctl";
    license = lib.licenses.lgpl21Only;
    maintainers = [ ];
    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
  };
})
