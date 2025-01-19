{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  which,
  perl,
  jq,
  libXrandr,
  coreutils,
  cairo,
  dbus,
  systemd,
  gdk-pixbuf,
  glib,
  libX11,
  libXScrnSaver,
  wayland,
  wayland-protocols,
  libXinerama,
  libnotify,
  pango,
  xorgproto,
  librsvg,
  testers,
  nix-update-script,
  withX11 ? true,
  withWayland ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dunst";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "dunst-project";
    repo = "dunst";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-rnR/AErsjsaOMM/aF8VXZHV8b8OiUMRCi8IFLT4/8Vo=";
  };

  nativeBuildInputs = [
    perl
    pkg-config
    which
    systemd
    makeWrapper
  ];

  buildInputs =
    [
      cairo
      dbus
      gdk-pixbuf
      glib
      libnotify
      pango
      librsvg
    ]
    ++ lib.optionals withX11 [
      libX11
      libXScrnSaver
      libXinerama
      xorgproto
      libXrandr
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
    "SYSCONFDIR=$(out)/etc"
    "SERVICEDIR_DBUS=$(out)/share/dbus-1/services"
    "SERVICEDIR_SYSTEMD=$(out)/lib/systemd/user"
  ] ++ lib.optional (!withX11) "X11=0" ++ lib.optional (!withWayland) "WAYLAND=0";

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

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Lightweight and customizable notification daemon";
    homepage = "https://dunst-project.org/";
    license = lib.licenses.bsd3;
    mainProgram = "dunst";
    maintainers = with lib.maintainers; [
      domenkozar
      gepbird
    ];
    # NOTE: 'unix' or even 'all' COULD work too, I'm not sure
    platforms = lib.platforms.linux;
  };
})
