{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  dbus,
  systemdLibs,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "org-freedesktop-filemanager1-common";
  version = "0-unstable-2025-10-12";

  src = fetchFromGitHub {
    owner = "boydaihungst";
    repo = "org.freedesktop.FileManager1.common";
    rev = "7f516129ac71be409dc415421859de68c1a2ed0e";
    hash = "sha256-FCmNqz8JaP6XUaJOoWw5Lfls3ThdY+Yv2kRdk8XIRic=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    dbus
    systemdLibs
  ];

  postInstall = ''
    for file in $out/share/org.freedesktop.FileManager1.common/*-wrapper.sh; do
      name=''${file##*/}
      name=''${name%-wrapper.sh}
      sed -i "s|^cmd=.*|cmd=\"$name\"|" "$file"
    done
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Using File Manager DBus Interface to open file manager and hover over file(s)/folder(s)";
    homepage = "https://github.com/boydaihungst/org.freedesktop.FileManager1.common";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anninzy ];
    platforms = lib.platforms.linux;
  };
})
