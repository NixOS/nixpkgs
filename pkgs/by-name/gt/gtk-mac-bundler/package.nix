{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "gtk-mac-bundler";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "GNOME";
    repo = "gtk-mac-bundler";
    rev = "bundler-${version}";
    hash = "sha256-6q+pHzR6cFYmoz00n3n8amSwX6PAObfgLvEEwaDA3s8=";
  };

  installPhase = ''
    mkdir -p $out/bin
    substitute gtk-mac-bundler.in $out/bin/gtk-mac-bundler \
      --subst-var-by PATH $out/share
    chmod a+x $out/bin/gtk-mac-bundler

    mkdir -p $out/share
    cp -r bundler $out/share
  '';

  meta = {
    description = "Helper script that creates application bundles form GTK executables for macOS";
    maintainers = [ ];
    platforms = lib.platforms.darwin;
    homepage = "https://gitlab.gnome.org/GNOME/gtk-mac-bundler";
    license = lib.licenses.gpl2;
  };
}
