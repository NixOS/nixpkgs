{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  wayland,
  wayland-protocols,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fwbuilder";
  version = "6.0.0-rc1";

  src = fetchFromGitHub {
    owner = "fwbuilder";
    repo = "fwbuilder";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j5HjGcIqq93Ca9OBqEgSotoSXyw+q6Fqxa3hKk1ctwQ=";
  };

  postPatch = ''
    # Avoid blanket -Werror as it triggers on any minor compiler
    # warnings like deprecated functions or invalid indentat8ion.
    # Leave fixing these problems to upstream.
    substituteInPlace CMakeLists.txt --replace ';-Werror;' ';'
  '';

  nativeBuildInputs = [
    cmake
    ninja
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    wayland
    wayland-protocols
    libsForQt5.qtwayland
  ];

  meta = {
    description = "GUI Firewall Management Application";
    longDescription = ''
      Firewall Builder is a GUI firewall management application for iptables,
      PF, Cisco ASA/PIX/FWSM, Cisco router ACL and more. Firewall configuration
      data is stored in a central file that can scale to hundreds of firewalls
      managed from a single UI.
    '';
    homepage = "https://github.com/fwbuilder/fwbuilder";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ elatov ];
  };
})
