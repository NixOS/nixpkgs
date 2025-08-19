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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "Browsers-software";
    repo = "browsers";
    tag = version;
    hash = "sha256-s03BEscaYdSitLtlqbX/tgGSLRHuXc9Ht+3RMCUIdY8=";
  };

  cargoHash = "sha256-tz4ju0NwgG5yb1VndYqyf+g631izPl904KYDUvawO28=";

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
    mainProgram = "browsers";
  };
}
