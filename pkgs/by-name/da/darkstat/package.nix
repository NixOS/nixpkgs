{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  fetchpatch,
  libpcap,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "darkstat";
  version = "3.0.721";

  src = fetchFromGitHub {
    owner = "emikulic";
    repo = "darkstat";
    tag = version;
    hash = "sha256-kKj4fCgphoe3lojJfARwpITxQh7E6ehUew9FVEW63uQ=";
  };

  patches = [
    # Avoid multiple definitions of CLOCK_REALTIME on macOS 11,
    # see https://github.com/emikulic/darkstat/pull/2
    (fetchpatch {
      url = "https://github.com/emikulic/darkstat/commit/d2fd232e1167dee6e7a2d88b9ab7acf2a129f697.diff";
      sha256 = "0z5mpyc0q65qb6cn4xcrxl0vx21d8ibzaam5kjyrcw4icd8yg4jb";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    libpcap
    zlib
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Network statistics web interface";
    longDescription = ''
      Captures network traffic, calculates statistics about usage, and serves
      reports over HTTP. Features:
      - Traffic graphs, reports per host, shows ports for each host.
      - Embedded web-server with deflate compression.
      - Asynchronous reverse DNS resolution using a child process.
      - Small. Portable. Single-threaded. Efficient.
      - Supports IPv6.
    '';
    homepage = "http://unix4lyfe.org/darkstat";
    changelog = "https://github.com/emikulic/darkstat/releases/tag/${version}";
    license = lib.licenses.gpl2Only;
    platforms = with lib.platforms; unix;
    mainProgram = "darkstat";
  };
}
