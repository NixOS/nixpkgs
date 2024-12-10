{
  lib,
  stdenv,
  pkg-config,
  dbus,
  vulkan-loader,
  libGL,
  fetchFromGitHub,
  rustPlatform,
  libxkbcommon,
  wayland,
}:

rustPlatform.buildRustPackage rec {
  pname = "centerpiece";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "friedow";
    repo = "centerpiece";
    rev = "v${version}";
    hash = "sha256-I630XrmyRAjVxFvISo2eIUP3YmivZovnV89Xsx5OduY=";
  };

  cargoHash = "sha256-yvvMe1zBUREqRzp/0zYsu7AoXS9Jqq67DY5uMParhEs=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    dbus
    libGL
    libxkbcommon
    vulkan-loader
    wayland
  ];

  postFixup = lib.optional stdenv.isLinux ''
    rpath=$(patchelf --print-rpath $out/bin/centerpiece)
    patchelf --set-rpath "$rpath:${
      lib.makeLibraryPath [
        libGL
        libxkbcommon
        vulkan-loader
        wayland
      ]
    }" $out/bin/centerpiece
  '';

  meta = with lib; {
    homepage = "https://github.com/friedow/centerpiece";
    description = "Your trusty omnibox search";
    license = licenses.mit;
    maintainers = with maintainers; [ a-kenji ];
    platforms = platforms.linux;
    mainProgram = "centerpiece";
  };
}
