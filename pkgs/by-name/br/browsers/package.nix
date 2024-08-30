{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook3,
  atk,
  cairo,
  gdk-pixbuf,
  glib,
  gtk3,
  pango,
}:

rustPlatform.buildRustPackage rec {
  pname = "browsers";
  version = "0.5.8";

  src = fetchFromGitHub {
    owner = "Browsers-software";
    repo = "browsers";
    rev = "refs/tags/${version}";
    hash = "sha256-o9vyrHQsZQ3qywA4bviM+W4xx64IZL24VHErMFAEMFE=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "druid-0.8.3" = "sha256-s9csjZ0ZimOrPnjJpPjrrMdNKAXFfroWHBPeR369Phk=";
      "rolling-file-0.2.0" = "sha256-3xeOSXFVVgeKRE39gtzTURt0OkKScQ4uwtvLl4CE3R4=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    atk
    cairo
    gdk-pixbuf
    glib
    gtk3
    pango
  ];

  postInstall = ''
    install -m 444 \
        -D extra/linux/dist/software.Browsers.template.desktop \
        -t $out/share/applications
    mv $out/share/applications/software.Browsers.template.desktop $out/share/applications/software.Browsers.desktop
    substituteInPlace \
        $out/share/applications/software.Browsers.desktop \
        --replace-fail 'Exec=€ExecCommand€' 'Exec=${pname} %u'
    cp -r resources $out
    for size in 16 32 128 256 512; do
      install -m 444 \
          -D resources/icons/"$size"x"$size"/software.Browsers.png \
          -t $out/share/icons/hicolor/"$size"x"$size"/apps
    done
  '';

  meta = {
    description = "Open the right browser at the right time";
    homepage = "https://browsers.software";
    changelog = "https://github.com/Browsers-software/browsers/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ravenz46 ];
    platforms = lib.platforms.linux;
    mainProgram = "browsers";
  };
}
