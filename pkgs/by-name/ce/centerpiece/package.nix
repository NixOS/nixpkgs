{ lib
, stdenv
, pkg-config
, dbus
, vulkan-loader
, libGL
, fetchFromGitHub
, rustPlatform
, libxkbcommon
, wayland
, enableX11 ? true, xorg
}:

rustPlatform.buildRustPackage rec {
  pname = "centerpiece";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "friedow";
    repo = "centerpiece";
    rev = "v${version}";
    hash = "sha256-1sKUGTBS9aTCQPuhkwv9fZ8F3N6yn98927fpp1e4fBU=";
  };

  cargoHash = "sha256-b7gI6Z5fiOA/Q2BbsmmGrKHgMzbICKPeK2i6YjlLnDo=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    dbus
    libGL
    libxkbcommon
    vulkan-loader
    wayland
  ] ++ lib.optionals enableX11 (with xorg; [
    libX11
    libXcursor
    libXi
    libXrandr
  ]);

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
    maintainers = with maintainers; [ a-kenji friedow ];
    platforms = platforms.linux;
    mainProgram = "centerpiece";
  };
}
