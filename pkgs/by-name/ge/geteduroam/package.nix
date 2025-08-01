{
  lib,
  buildGoModule,
  fetchFromGitHub,
  symlinkJoin,
  versionCheckHook,
  makeWrapper,
  wrapGAppsHook4,
  cairo,
  gdk-pixbuf,
  glib,
  graphene,
  gtk4,
  libadwaita,
  pango,
}:

buildGoModule (finalAttrs: {
  pname = "geteduroam";
  version = "0.12";

  src = fetchFromGitHub {
    owner = "geteduroam";
    repo = "linux-app";
    tag = finalAttrs.version;
    hash = "sha256-+3mluLby3R0xVU9fIG+1B1A4yM1IfyUvw4wclwnV5s8=";
  };

  vendorHash = "sha256-l9hge1TS+7ix9/6LKWq+lTMjNM4/Lnw8gNrWB6hWCTk=";

  subPackages = [
    "cmd/geteduroam-gui"
    "cmd/geteduroam-notifcheck"
  ];

  postInstall = ''
    wrapProgram $out/bin/geteduroam-gui \
      --set-default PUREGOTK_LIB_FOLDER ${finalAttrs.passthru.libraryPath}/lib \
      ''${gappsWrapperArgs[@]}

    # copy notifcheck service
    mkdir -p $out/lib/systemd/system/
    cp -v systemd/user/geteduroam/* $out/lib/systemd/system/
    substituteInPlace $out/lib/systemd/system/geteduroam-notifs.service \
      --replace-fail \
        "ExecStart=/usr/bin/geteduroam-notifcheck" \
        "ExecStart=$out/bin/geteduroam-notifcheck"

    # copy icons and desktop entries
    cp -r cmd/geteduroam-gui/resources/share $out/
  '';

  nativeBuildInputs = [
    wrapGAppsHook4
    makeWrapper
  ];

  dontWrapGApps = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/geteduroam-gui";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    libraryPath = symlinkJoin {
      name = "eduroam-gui-puregotk-lib";
      # based on https://github.com/jwijenbergh/puregotk/blob/bc1a52f44fd4c491947f7af85296c66173da17ba/internal/core/core.go#L41
      paths = [
        cairo
        gdk-pixbuf
        glib.out
        graphene
        gtk4
        libadwaita
        pango.out
      ];
    };
  };

  meta = {
    description = "GUI client to configure eduroam";
    homepage = "https://eduroam.app";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pbsds ];
    platforms = lib.platforms.linux;
    changelog = "https://github.com/geteduroam/linux-app/releases/tag/${finalAttrs.version}";
    mainProgram = "geteduroam-gui";
  };
})
