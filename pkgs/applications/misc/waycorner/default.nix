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
  version = "0.2.1";
  src = fetchFromGitHub {
    owner = "AndreasBackx";
    repo = "waycorner";
    rev = version;
    hash = "sha256-xvmvtn6dMqt8kUwvn5d5Nl1V84kz1eWa9BSIN/ONkSQ=";
  };
  cargoHash = "sha256-Dl+GhJywWhaC4QMS70klazPsFipGVRW+6jrXH2XsEAI=";
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
    changelog = "https://github.com/AndreasBackx/waycorner/blob/main/CHANGELOG.md";
    homepage = "https://github.com/AndreasBackx/waycorner";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ NotAShelf ];
  };
}
