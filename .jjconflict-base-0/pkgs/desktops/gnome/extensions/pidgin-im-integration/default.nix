{ lib, stdenv, fetchFromGitHub, glib, gnome-shell }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-pidgin-im-integration";
  version = "32";

  src = fetchFromGitHub {
    owner = "muffinmad";
    repo = "pidgin-im-gnome-shell-extension";
    rev = "v${version}";
    sha256 = "1jyg8r0s1v83sgg6y0jbsj2v37mglh8rvd8vi27fxnjq9xmg8kpc";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    share_dir="$prefix/share"
    extensions_dir="$share_dir/gnome-shell/extensions/pidgin@muffinmad"
    mkdir -p "$extensions_dir"
    mv *.js metadata.json dbus.xml schemas locale "$extensions_dir"
    runHook postInstall
  '';

  passthru = {
    extensionUuid = "pidgin@muffinmad";
    extensionPortalSlug = "pidgin-im-integration";
  };

  meta = with lib; {
    homepage = "https://github.com/muffinmad/pidgin-im-gnome-shell-extension";
    description = "Make Pidgin IM conversations appear in the Gnome Shell message tray";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ ];
    broken = versionAtLeast gnome-shell.version "3.32"; # Doesn't support 3.34
  };
}
