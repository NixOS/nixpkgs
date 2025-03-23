{
  ioquake3,
  fetchFromGitHub,
  pan-bindings,
  libsodium,
  lib,
}:
ioquake3.overrideAttrs (old: {
  pname = "ioq3-scion";
  version = "unstable-2024-03-03";
  buildInputs = old.buildInputs ++ [
    pan-bindings
    libsodium
  ];
  src = fetchFromGitHub {
    owner = "lschulz";
    repo = "ioq3-scion";
    rev = "9f06abd5030c51cd4582ba3d24ba87531e3eadbc";
    hash = "sha256-+zoSlNT+oqozQFnhA26PiMo1NnzJJY/r4tcm2wOCBP0=";
  };
  meta = {
    description = "ioquake3 with support for path aware networking";
    maintainers = with lib.maintainers; [ matthewcroughan ];
  };
})
