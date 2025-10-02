{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  pkg-config,
  expat,
  fontconfig,
  freetype,
  libGL,
  xorg,
}:

rustPlatform.buildRustPackage rec {
  pname = "epick";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "vv9k";
    repo = "epick";
    # Upstream has rewritten tags on multiple occasions.
    rev = "14ee92e049780406fffdc1e4a83bf1433775663f";
    sha256 = "sha256-gjqAQrGJ9KFdzn2a3fOgu0VJ9zrX5stsbzriOGJaD/4=";
  };

  cargoHash = "sha256-r/0aNzU8jm2AqiZWq4plxXY/H7qKVC8nEI9BwOUKCdA=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    expat
    fontconfig
    freetype
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
  ];

  postInstall = ''
    install -Dm444 assets/epick.desktop -t $out/share/applications
    install -Dm444 assets/icon.svg $out/share/icons/hicolor/scalable/apps/epick.svg
    install -Dm444 assets/icon.png $out/share/icons/hicolor/48x48/apps/epick.png
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf $out/bin/epick --add-rpath ${lib.makeLibraryPath [ libGL ]}
  '';

  meta = {
    description = "Simple color picker that lets the user create harmonic palettes with ease";
    homepage = "https://github.com/vv9k/epick";
    changelog = "https://github.com/vv9k/epick/blob/${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "epick";
  };
}
