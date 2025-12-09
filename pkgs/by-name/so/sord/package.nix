{
  lib,
  stdenv,
  doxygen,
  fetchFromGitLab,
  meson,
  ninja,
  pcre2,
  pkg-config,
  python3,
  serd,
  zix,
}:

stdenv.mkDerivation rec {
  pname = "sord";
  version = "0.16.20";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "drobilla";
    repo = "sord";
    tag = "v${version}";
    hash = "sha256-+f3dxhcxVoub+KeI5c5/J87SVvAawrm5cZgo2qogdRM=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
    "man"
  ];

  nativeBuildInputs = [
    doxygen
    meson
    ninja
    pkg-config
    python3
  ];
  buildInputs = [ pcre2 ];
  propagatedBuildInputs = [
    serd
    zix
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "http://drobilla.net/software/sord";
    description = "Lightweight C library for storing RDF data in memory";
    license = with licenses; [
      bsd0
      isc
    ];
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
