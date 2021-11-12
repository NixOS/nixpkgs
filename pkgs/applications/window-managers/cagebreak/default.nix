{ lib
, stdenv
, fetchFromGitHub
, cairo
, fontconfig
, libevdev
, libinput
, libxkbcommon
, makeWrapper
, mesa
, meson
, ninja
, nixosTests
, pango
, pixman
, pkg-config
, scdoc
, systemd
, wayland
, wayland-protocols
, withXwayland ? true , xwayland
, wlroots
}:

stdenv.mkDerivation rec {
  pname = "cagebreak";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "project-repo";
    repo = pname;
    rev = version;
    hash = "sha256-tWfHJajAOYZJ73GckZWWTdVz75YmHA7t/qDhM7+tJgk=";
  };

  nativeBuildInputs = [
    makeWrapper
    meson
    ninja
    pkg-config
    scdoc
    wayland
  ];

  buildInputs = [
    cairo
    fontconfig
    libevdev
    libinput
    libxkbcommon
    mesa # for libEGL headers
    pango
    pixman
    systemd
    wayland
    wayland-protocols
    wlroots
  ];

  mesonFlags = [
    "-Dman-pages=true"
    "-Dversion_override=${version}"
    "-Dxwayland=${lib.boolToString withXwayland}"
  ];

  # TODO: investigate why is this happening
  postPatch = ''
    sed -i -e 's|<drm_fourcc.h>|<libdrm/drm_fourcc.h>|' *.c
  '';

  postInstall = ''
    install -d $out/share/cagebreak/
    install -m644 $src/examples/config $out/share/cagebreak/
  '';

  postFixup = lib.optionalString withXwayland ''
    wrapProgram $out/bin/cagebreak \
      --prefix PATH : "${lib.makeBinPath [ xwayland ]}"
  '';

  meta = with lib; {
    homepage = "https://github.com/project-repo/cagebreak";
    description = "A Wayland tiling compositor inspired by ratpoison";
    license = licenses.mit;
    maintainers = with maintainers; [ berbiche ];
    platforms = platforms.linux;
  };

  passthru.tests.basic = nixosTests.cagebreak;
}
