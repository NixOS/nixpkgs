{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  utf8cpp,
  libtool,
  libxml2,
  icu,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "lttoolbox";
  version = "3.8.2";

  src = fetchFromGitHub {
    owner = "apertium";
    repo = "lttoolbox";
    tag = "v${version}";
    hash = "sha256-g9mWHd9MzVKg/6zF7Fh7owFM3uX9vOQzX0IkrEzr5LY=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    utf8cpp
    libtool
  ];
  buildInputs = [
    libxml2
    icu
  ];
  buildFlags = [
    "CPPFLAGS=-I${utf8cpp}/include/utf8cpp"
  ];
  cmakeFlags = [
  ];

  # Workaround based on
  # https://github.com/NixOS/nixpkgs/issues/144170#issuecomment-1423195220
  # for https://github.com/apertium/lttoolbox/issues/207
  preInstall = ''
    sed -i.tmp 's,[$$]{\(exec_\)*prefix}//nix/store,/nix/store,' ./lttoolbox.pc
    rm ./lttoolbox.pc.tmp
  '';

  nativeCheckInputs = [ python3 ];
  doCheck = true;

  meta = {
    description = "Finite state compiler, processor and helper tools used by apertium";
    homepage = "https://github.com/apertium/lttoolbox";
    maintainers = with lib.maintainers; [ onthestairs ];
    changelog = "https://github.com/apertium/lttoolbox/releases/tag/v${version}";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
