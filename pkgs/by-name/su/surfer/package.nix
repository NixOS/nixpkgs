{
  lib,
  fetchFromGitLab,
  rustPlatform,
  pkg-config,
  openssl,
  wayland,
  libxkbcommon,
  libGL,
}:
rustPlatform.buildRustPackage rec {
  pname = "surfer";
  version = "v0.2.0";

  src = fetchFromGitLab {
    owner = "surfer-project";
    repo = pname;
    rev = version;
    hash = "sha256-C5jyWLs7fdEn2oW5BORZYazQwjXNxf8ketYFwlVkHpA";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [pkg-config];
  buildInputs = [openssl wayland libxkbcommon libGL];

  # These libraries are dlopen'ed at runtime, but they won't be able to find anything in
  # NixOS's path. So force them to be linked.
  # This could alternatively be a wrapper which adds LD_LIBRARY_PATH.
  RUSTFLAGS = map (a: "-C link-arg=${a}") [
    "-Wl,--push-state,--no-as-needed"
    "-lEGL"
    "-lwayland-client"
    "-lxkbcommon"
    "-Wl,--pop-state"
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "codespan-0.12.0" = "sha256-3F2006BR3hyhxcUTaQiOjzTEuRECKJKjIDyXonS/lrE=";
      "egui_skia-0.5.0" = "sha256-dpkcIMPW+v742Ov18vjycLDwnn1JMsvbX6qdnuKOBC4=";
      "tracing-tree-0.2.0" = "sha256-/JNeAKjAXmKPh0et8958yS7joORDbid9dhFB0VUAhZc=";
    };
  };

  doCheck = false;

  meta = {
    description = "An Extensible and Snappy Waveform Viewer";
    homepage = "http://surfer-project.org/";
    license = lib.licenses.eupl12;
    maintainers = [];
    platforms = lib.platforms.linux;
    mainProgram = "surfer";
  };
}
