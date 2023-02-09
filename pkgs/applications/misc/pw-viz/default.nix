{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, expat
, fontconfig
, freetype
, libGL
, libxkbcommon
, pipewire
, wayland
, xorg
}:

rustPlatform.buildRustPackage rec {
  pname = "pw-viz";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ax9d";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lw4whdh8tNoS5XUlamQCq8f8z8K59uD90PSSo3skeyo=";
  };

  cargoSha256 = "sha256-XmvM5tr6ToYi0UrFnLju1wmp/0VEEP/O7T9Bx0YyFW4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    expat
    fontconfig
    freetype
    libGL
    libxkbcommon
    pipewire
    rustPlatform.bindgenHook
    wayland
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
  ];

  postFixup = ''
    patchelf $out/bin/pw-viz \
      --add-rpath ${lib.makeLibraryPath [ libGL libxkbcommon wayland ]}
  '';

  # enables pipewire API deprecated in 0.3.64
  # fixes error caused by https://gitlab.freedesktop.org/pipewire/pipewire-rs/-/issues/55
  NIX_CFLAGS_COMPILE = [ "-DPW_ENABLE_DEPRECATED" ];

  meta = with lib; {
    description = "A simple and elegant pipewire graph editor ";
    homepage = "https://github.com/ax9d/pw-viz";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
    platforms = platforms.linux;
  };
}
