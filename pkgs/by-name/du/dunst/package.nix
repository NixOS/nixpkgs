{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  which,
  perl,
  jq,
  libxrandr,
  coreutils,
  cairo,
  dbus,
  systemd,
  gdk-pixbuf,
  glib,
  libx11,
  libxscrnsaver,
  wayland,
  wayland-protocols,
  libxinerama,
  libnotify,
  pango,
  xorgproto,
  librsvg,
  versionCheckHook,
  nix-update-script,
  withX11 ? true,
  withWayland ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dunst";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "dunst-project";
    repo = "dunst";
    tag = "v${finalAttrs.version}";
    hash = "sha256-F7CONYJ95aKNZ+BpWNUerCBMflgJYgSaLAqp6XJ1G5k=";
  };

  nativeBuildInputs = [
    perl
    pkg-config
    which
    systemd
    makeWrapper
  ];

  buildInputs = [
    cairo
    dbus
    gdk-pixbuf
    glib
    libnotify
    pango
    librsvg
  ]
  ++ lib.optionals withX11 [
    libx11
    libxscrnsaver
    libxinerama
    xorgproto
    libxrandr
  ]
  ++ lib.optionals withWayland [
    wayland
    wayland-protocols
  ];

  outputs = [
    "out"
    "man"
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "VERSION=$(version)"
    "SYSCONFDIR=/etc/xdg"
    "SYSCONF_FORCE_NEW=0"
    "SERVICEDIR_DBUS=$(out)/share/dbus-1/services"
    "SERVICEDIR_SYSTEMD=$(out)/lib/systemd/user"
  ]
  ++ lib.optional (!withX11) "X11=0"
  ++ lib.optional (!withWayland) "WAYLAND=0";

  postInstall = ''
    wrapProgram $out/bin/dunst \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE"

    wrapProgram $out/bin/dunstctl \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          dbus
        ]
      }"

    substituteInPlace \
      $out/share/zsh/site-functions/_dunstctl \
      $out/share/bash-completion/completions/dunstctl \
      $out/share/fish/vendor_completions.d/{dunstctl,dunstify}.fish \
      --replace-fail "jq" "${lib.getExe jq}"
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Lightweight and customizable notification daemon";
    homepage = "https://dunst-project.org/";
    changelog = "https://github.com/dunst-project/dunst/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    mainProgram = "dunst";
    maintainers = with lib.maintainers; [
      gepbird
    ];
    # NOTE: 'unix' or even 'all' COULD work too, I'm not sure
    platforms = lib.platforms.linux;
  };
})
