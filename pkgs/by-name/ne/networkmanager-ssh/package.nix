{
  stdenv,
  lib,
  autoreconfHook,
  fetchFromGitHub,
  pkg-config,
  networkmanager,
  libsecret,
  gtk3,
  gtk4,
  libnma-gtk4,
  intltool,
  openssh,
  sshpass,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "NetworkManager-ssh";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "danfruehauf";
    repo = "NetworkManager-ssh";
    tag = finalAttrs.version;
    hash = "sha256-ExCU22V4fYuFXW/HqJ39+PbYykXu4rpk8+3/hg9KTMo=";
  };

  postPatch = ''
    substituteInPlace src/nm-ssh-service.c \
      --replace-fail /usr/bin/sshpass ${lib.getExe sshpass} \
      --replace-fail /usr/bin/ssh ${lib.getExe openssh}
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    intltool
    gtk4
  ];

  buildInputs = [
    networkmanager
    gtk3
    gtk4
    libsecret
    libnma-gtk4
  ];

  configureFlags = [
    "--with-gtk4"
    "--enable-absolute-paths"
  ];

  strictDeps = true;

  passthru = {
    networkManagerPlugin = "VPN/nm-ssh-service.name";
  };

  meta = {
    description = "SSH VPN integration for NetworkManager";
    homepage = "https://github.com/danfruehauf/NetworkManager-ssh";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      zhangxy
    ];
    inherit (networkmanager.meta) platforms;
  };
})
