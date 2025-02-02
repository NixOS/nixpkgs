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
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "friedow";
    repo = "centerpiece";
    rev = "v${version}";
    hash = "sha256-tZNwMPL1ITWVvoywojsd5j0GIVQt6pOKFLwi7jwqLKg=";
  };

  cargoHash = "sha256-d5qGuQ8EnIkE/PhI9t4JxtnNbvh3rse9NpowZ+ESZuU=";

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

  postFixup = lib.optional stdenv.hostPlatform.isLinux ''
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
