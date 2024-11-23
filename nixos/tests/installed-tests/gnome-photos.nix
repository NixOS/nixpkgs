{ pkgs, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.gnome-photos;

  withX11 = true;

  testConfig = {
    programs.dconf.enable = true;
    services.gnome.at-spi2-core.enable = true; # needed for dogtail
    environment.systemPackages = with pkgs; [
      # gsettings tool with access to gsettings-desktop-schemas
      (stdenv.mkDerivation {
        name = "desktop-gsettings";
        dontUnpack = true;
        nativeBuildInputs = [
          glib
          wrapGAppsHook3
        ];
        buildInputs = [ gsettings-desktop-schemas ];
        installPhase = ''
          runHook preInstall
          mkdir -p $out/bin
          ln -s ${glib.bin}/bin/gsettings $out/bin/desktop-gsettings
          runHook postInstall
        '';
      })
    ];
    services.dbus.packages = with pkgs; [ gnome-photos ];
  };

  preTestScript = ''
    # dogtail needs accessibility enabled
    machine.succeed(
        "desktop-gsettings set org.gnome.desktop.interface toolkit-accessibility true 2>&1"
    )
  '';
}
