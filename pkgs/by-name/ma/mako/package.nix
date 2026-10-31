{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  scdoc,
  systemdMinimal,
  basu,
  elogind,
  pango,
  cairo,
  gdk-pixbuf,
  wayland,
  wayland-scanner,
  wayland-protocols,

  busProvider ? "libsystemd",
  withManPages ? true,
  withBashCompletions ? true,
  withFishCompletions ? true,
  withZshCompletions ? true,
}:

assert lib.assertOneOf "busProvider" busProvider [
  "libsystemd"
  "libelogind"
  "basu"
];

stdenv.mkDerivation (finalAttrs: {
  pname = "mako";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "mako";
    tag = "v${finalAttrs.version}";
    hash = "sha256-opCAkYVhp2zQNEi4NBiFfXsC0DdL0kZtaXS9/epzF10=";
  };

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-protocols
    wayland-scanner
  ]
  ++ lib.optional withManPages scdoc;
  buildInputs = [
    pango
    cairo
    gdk-pixbuf
    wayland
  ]
  ++ lib.optional (busProvider == "libsystemd") systemdMinimal
  ++ lib.optional (busProvider == "libelogind") elogind
  ++ lib.optional (busProvider == "basu") basu;

  mesonFlags = [
    (lib.mesonBool "bash-completions" withBashCompletions)
    (lib.mesonBool "fish-completions" withFishCompletions)
    (lib.mesonBool "zsh-completions" withZshCompletions)
    (lib.mesonEnable "man-pages" withManPages)
    (lib.mesonOption "sd-bus-provider" busProvider)
  ];

  postInstall = lib.optionalString (busProvider == "libsystemd") ''
    mkdir -p $out/lib/systemd/user
    substitute $src/contrib/systemd/mako.service $out/lib/systemd/user/mako.service \
      --replace-fail '/usr/bin' "$out/bin"
    chmod 0644 $out/lib/systemd/user/mako.service

    # Route D-Bus activation through the unit installed above, so it
    # waits for graphical-session.target instead of exec'ing mako
    # before the compositor is up.
    echo "SystemdService=mako.service" \
      >> $out/share/dbus-1/services/fr.emersion.mako.service
  '';

  meta = {
    description = "Lightweight Wayland notification daemon";
    homepage = "https://github.com/emersion/mako";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dywedir
    ];
    platforms = lib.platforms.linux;
    mainProgram = "mako";
  };
})
