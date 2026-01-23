{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  libGL,
  libxxf86vm,
  libxrandr,
  libxi,
  libxinerama,
  libxext,
  libxcursor,
  libx11,
}:

buildGoModule rec {
  pname = "rymdport";
  version = "3.9.1";

  src = fetchFromGitHub {
    owner = "Jacalz";
    repo = "rymdport";
    rev = "v${version}";
    hash = "sha256-5INmb8zMFUB8ibA+ACNWoL54tOhWYHF85MZzRNRmJow=";
  };

  vendorHash = "sha256-WPJj3zlEJeghRw0lHHUXm7n0a6d8Yf78s7jnBwmAZ4U=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libGL
    libx11
    libxcursor
    libxext
    libxi
    libxinerama
    libxrandr
    libxxf86vm
  ];

  postInstall = ''
    for res in $(ls internal/assets/icons | sed -e 's/icon-//g' -e 's/.png//g'); do
      install -Dm444 internal/assets/icons/icon-$res.png \
        $out/share/icons/hicolor/''${res}x''${res}/apps/io.github.jacalz.rymdport.png
    done
    install -Dm444 internal/assets/svg/icon.svg $out/share/icons/hicolor/scalable/apps/io.github.jacalz.rymdport.svg
    install -Dm444 internal/assets/unix/io.github.jacalz.rymdport.desktop -t $out/share/applications
  '';

  meta = {
    description = "Easy encrypted file, folder, and text sharing between devices";
    homepage = "https://github.com/Jacalz/rymdport";
    changelog = "https://github.com/Jacalz/rymdport/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "rymdport";
  };
}
