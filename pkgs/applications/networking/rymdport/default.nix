{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, pkg-config
, libGL
, xorg
, Carbon
, Cocoa
}:

buildGoModule rec {
  pname = "rymdport";
  version = "3.5.2";

  src = fetchFromGitHub {
    owner = "Jacalz";
    repo = "rymdport";
    rev = "v${version}";
    hash = "sha256-LTCr1OFh+1QQhXFNl9SoLPqEY0ERlLlWfSxRKjyyqPk=";
  };

  vendorHash = "sha256-twXeLNWy/5wTaFb645mCeI5PzByEGj5aCWl6vO+qRLQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = with xorg; [
    libGL
    libX11
    libXcursor
    libXext
    libXi
    libXinerama
    libXrandr
    libXxf86vm
  ] ++ lib.optionals stdenv.isDarwin [
    Carbon
    Cocoa
    IOKit
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
    platforms = lib.platforms.linux;
    mainProgram = "rymdport";
  };
}
