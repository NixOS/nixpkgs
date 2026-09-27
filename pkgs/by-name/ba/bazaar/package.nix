{
  lib,
  stdenv,
  fetchFromGitLab,
  blueprint-compiler,
  desktop-file-utils,
  dbus,
  meson,
  python3,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook4,
  appstream,
  flatpak,
  glib-networking,
  glycin-loaders,
  gtk4,
  gtksourceview5,
  json-glib,
  libadwaita,
  libdex,
  libglycin,
  libglycin-gtk4,
  libproxy,
  libsoup_3,
  libxmlb,
  libxml2,
  libyaml,
  malcontent,
  md4c,
  webkitgtk_6_0,
  libsecret,
  systemdLibs,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bazaar";
  version = "0.9.6";

  __structuredAttrs = true;
  strictDeps = true;

  outputs = [
    "out"
    # for libbge
    "lib"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "bazaar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-88WdIONlrluS+9ojToKopBMxYiqWKPhYuiPDNMv2iDw=";
  };

  postPatch = ''
    # The generated Vala C code includes headers that require these dependencies.
    substituteInPlace src/meson.build \
      --replace-fail 'vala_deps = [' \
        "vala_deps = [declare_dependency(compile_args: run_command('pkg-config', '--cflags', 'appstream', 'flatpak', check: true).stdout().strip().split()),"
  '';

  nativeBuildInputs = [
    blueprint-compiler
    desktop-file-utils
    libxml2
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
    (python3.withPackages (p: [
      p.babel
      p.pygobject3
    ]))
  ];

  buildInputs = [
    appstream
    dbus
    flatpak
    glib-networking
    gtk4
    gtksourceview5
    json-glib
    libadwaita
    libdex
    libglycin
    libglycin-gtk4
    glycin-loaders
    libproxy
    libsoup_3
    libxmlb
    libyaml
    malcontent
    md4c
    webkitgtk_6_0
    libsecret
    systemdLibs
  ];

  postInstall = ''
    moveToOutput bin/bge-demo $dev
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      # bazaar needs bazaar-dl-worker in path
      --prefix PATH : $out/bin
      --prefix LD_LIBRARY_PATH : $lib/lib
      # gsettings schemas are moved to $lib
      --prefix XDG_DATA_DIRS : $lib/share
    )

    # isn't automatically picked out for some reason, while $dev/bin/bge-demo is...
    wrapGApp $out/bin/bazaar
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "FlatHub-first app store for GNOME";
    homepage = "https://gitlab.gnome.org/World/bazaar";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      dtomvan
    ];
    mainProgram = "bazaar";
    platforms = lib.platforms.linux;
  };
})
