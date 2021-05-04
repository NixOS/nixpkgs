{ lib
, stdenv
, fetchFromGitHub
, cairo
, fontconfig
, libxkbcommon
, makeWrapper
, mesa
, meson
, ninja
, nixosTests
, pandoc
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
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "project-repo";
    repo = pname;
    rev = version;
    hash = "sha256-HpAjJHu5sxZKof3ydnU3wcP5GpnH6Ax8m1T1vVoq+oI=";
  };

  nativeBuildInputs = [
    makeWrapper
    meson
    ninja
    pandoc
    pkg-config
    scdoc
    wayland
  ];

  buildInputs = [
    cairo
    fontconfig
    libxkbcommon
    mesa # for libEGL headers
    pango
    pixman
    systemd
    wayland
    wayland-protocols
    wlroots
  ];

  outputs = [
    "out"
    "contrib"
  ];

  mesonFlags = [
    "-Dman-pages=true"
    "-Dversion_override=${version}"
    "-Dxwayland=${lib.boolToString withXwayland}"
  ];

  postPatch = ''
    sed -i -e 's|<drm_fourcc.h>|<libdrm/drm_fourcc.h>|' *.c
  '';

  postInstall = ''
    mkdir -p $contrib/share/cagebreak
    cp $src/examples/config $contrib/share/cagebreak/config
  '';

  postFixup = lib.optionalString withXwayland ''
    wrapProgram $out/bin/cagebreak --prefix PATH : "${xwayland}/bin"
  '';

  passthru.tests.basic = nixosTests.cagebreak;

  meta = with lib; {
    description = "A Wayland tiling compositor inspired by ratpoison";
    homepage = "https://github.com/project-repo/cagebreak";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ berbiche ];
  };
}
