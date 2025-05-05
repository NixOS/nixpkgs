{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
}:

let
  name = "liblc3";
  version = "1.1.3";
in
stdenv.mkDerivation {
  pname = name;
  version = version;

  src = fetchFromGitHub {
    owner = "google";
    repo = "liblc3";
    rev = "v${version}";
    sha256 = "sha256-4KsvCQ1JZaj0yCT7En7ZcNk0rA8LyDwwcSga2IoVd6A=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    meson
    ninja
  ];

  meta = with lib; {
    description = "LC3 (Low Complexity Communication Codec) is an efficient low latency audio codec";
    homepage = "https://github.com/google/liblc3";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jansol ];
  };
}
