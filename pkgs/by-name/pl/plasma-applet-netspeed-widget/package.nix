{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "plasma-applet-netspeed-widget";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "dfaust";
    repo = "plasma-applet-netspeed-widget";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lP2wenbrghMwrRl13trTidZDz+PllyQXQT3n9n3hzrg=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/plasma/plasmoids
    cp -r package $out/share/plasma/plasmoids/org.kde.netspeedWidget

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/dfaust/plasma-applet-netspeed-widget/blob/${finalAttrs.src.rev}/ChangeLog";
    description = "Plasma 5 and 6 widget that displays the currently used network bandwidth";
    homepage = "https://github.com/dfaust/plasma-applet-netspeed-widget";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.linuxwhata ];
    platforms = lib.platforms.linux;
  };
})
