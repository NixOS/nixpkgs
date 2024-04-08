{ lib
, makeWrapper
, rustPlatform
, pkg-config
, fetchFromGitHub
, wayland
,
}:
rustPlatform.buildRustPackage rec {
  pname = "waycorner";
  version = "0.2.2";
  src = fetchFromGitHub {
    owner = "AndreasBackx";
    repo = "waycorner";
    rev = version;
    hash = "sha256-b0wGqtCvWzCV9mj2eZ0SXzxM02fbyQ+OfKcbZ2MhLOE=";
  };
  cargoHash = "sha256-Xl2nBBcfWjULKG2L+qX4ruw7gux6+qfFg/dTAarqgAU=";
  buildInputs = [
    wayland
  ];
  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];
  postFixup = ''
    # the program looks for libwayland-client.so at runtime
    wrapProgram $out/bin/waycorner \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ wayland ]}
  '';

  meta = with lib; {
    description = "Hot corners for Wayland";
    mainProgram = "waycorner";
    changelog = "https://github.com/AndreasBackx/waycorner/blob/main/CHANGELOG.md";
    homepage = "https://github.com/AndreasBackx/waycorner";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ NotAShelf ];
  };
}
