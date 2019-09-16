# run installed tests
import ./make-test.nix ({ pkgs, lib, ... }:

let

  # gsettings tool with access to gsettings-desktop-schemas
  desktop-gsettings = with pkgs; stdenv.mkDerivation {
    name = "desktop-gsettings";
    dontUnpack = true;
    nativeBuildInputs = [ glib wrapGAppsHook ];
    buildInputs = [ gsettings-desktop-schemas ];
    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      ln -s ${glib.bin}/bin/gsettings $out/bin/desktop-gsettings
      runHook postInstall
    '';
  };

in

{
  name = "gnome-photos";
  meta = {
    maintainers = pkgs.gnome-photos.meta.maintainers;
  };

  machine = { pkgs, ... }: {
    imports = [ ./common/x11.nix ];
    programs.dconf.enable = true;
    services.gnome3.at-spi2-core.enable = true; # needed for dogtail
    environment.systemPackages = with pkgs; [ gnome-desktop-testing desktop-gsettings ];
    services.dbus.packages = with pkgs; [ gnome-photos ];
  };

  testScript = ''
    $machine->waitForX;
    # dogtail needs accessibility enabled
    $machine->succeed("desktop-gsettings set org.gnome.desktop.interface toolkit-accessibility true 2>&1");
    $machine->succeed("gnome-desktop-testing-runner -d '${pkgs.gnome-photos.installedTests}/share' 2>&1");
  '';
})
