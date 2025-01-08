{
  lib,
  fetchFromGitHub,
  writeScript,
  unstableGitUpdater,
  rustPlatform,
  cmake,
  libGL,
  libinput,
  libxkbcommon,
  pkg-config,
  udev,
  wayland,
  xorg,
}:

rustPlatform.buildRustPackage rec {
  pname = "stardust-xr-non-spatial-input";
  version = "0-unstable-2024-06-01";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "non-spatial-input";
    rev = "42a23ba87322cf93602a81025f3ba1710d26dc1e";
    hash = "sha256-W5oAv9R8GsSPna1B/7LsUnDy74dtqZlR0gvme4CFapU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "stardust-xr-0.45.0" = "sha256-RPH00Vqy7eWJR+Sox+uVSLERO/lv3PJpzXwpqQAHBIA=";
      "stardust-xr-molecules-0.45.0" = "sha256-ZuJ7TUg4ancuQwkTmP7xTa+qEj3hsISj2vCn+z1CPHA=";
    };
  };
  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    libGL
    libinput
    libxkbcommon
    udev
    wayland
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
  ];

  passthru.updateScript = writeScript "${pname}-update" ''
    source ${builtins.head (unstableGitUpdater { })}
    cp $tmpdir/Cargo.lock ./pkgs/by-name/${builtins.substring 0 2 pname}/${pname}/Cargo.lock
  '';

  meta = {
    description = "TODO";
    homepage = "https://stardustxr.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pandapip1 ];
    platforms = lib.platforms.linux;
  };
}
