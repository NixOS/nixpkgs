{
  lib,
  stdenv,
  fetchFromGitHub,
  cairo,
  fontconfig,
  libdrm,
  libevdev,
  libinput,
  libxkbcommon,
  xcbutilwm,
  makeWrapper,
  meson,
  ninja,
  nixosTests,
  pango,
  pixman,
  pkg-config,
  scdoc,
  systemd,
  wayland,
  wayland-protocols,
  wayland-scanner,
  withXwayland ? true,
  xwayland,
  wlroots_0_18,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cagebreak";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "project-repo";
    repo = "cagebreak";
    tag = finalAttrs.version;
    hash = "sha256-vXRIZqFyywRettzriOArl1FGdzWdaeVOfYFZCiPLQZg=";
  };

  nativeBuildInputs = [
    makeWrapper
    meson
    ninja
    pkg-config
    scdoc
    wayland-scanner
  ];

  buildInputs = [
    cairo
    fontconfig
    libdrm
    libevdev
    libinput
    libxkbcommon
    xcbutilwm
    pango
    pixman
    systemd
    wayland
    wayland-protocols
    wlroots_0_18
  ];

  mesonFlags = [
    "-Dman-pages=true"
    "-Dversion_override=${finalAttrs.version}"
    "-Dxwayland=${lib.boolToString withXwayland}"
  ];

  postPatch = ''
    # TODO: investigate why is this happening
    sed -i -e 's|<drm_fourcc.h>|<libdrm/drm_fourcc.h>|' *.c

    # Patch cagebreak to read its default configuration from $out/share/cagebreak
    sed -i "s|/etc/xdg/cagebreak|$out/share/cagebreak|" meson.build cagebreak.c
    substituteInPlace meson.build \
      --replace "/usr/share/licenses" "$out/share/licenses"
  '';

  postFixup = lib.optionalString withXwayland ''
    wrapProgram $out/bin/cagebreak \
      --prefix PATH : "${lib.makeBinPath [ xwayland ]}"
  '';

  meta = {
    homepage = "https://github.com/project-repo/cagebreak";
    description = "Wayland tiling compositor inspired by ratpoison";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    changelog = "https://github.com/project-repo/cagebreak/blob/${finalAttrs.version}/Changelog.md";
    mainProgram = "cagebreak";
  };

  passthru.tests.basic = nixosTests.cagebreak;
})
