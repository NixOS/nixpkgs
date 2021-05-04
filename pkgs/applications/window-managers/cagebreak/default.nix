{ lib, stdenv, fetchFromGitHub
, meson, ninja, pkg-config, wayland, scdoc, makeWrapper
, wlroots, wayland-protocols, pixman, libxkbcommon
, cairo , pango, fontconfig, pandoc, systemd, mesa
, withXwayland ? true, xwayland
, nixosTests
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

  nativeBuildInputs = [ meson ninja pkg-config wayland scdoc pandoc makeWrapper ];

  buildInputs = [
    wlroots wayland wayland-protocols pixman libxkbcommon cairo
    pango fontconfig systemd
    mesa # for libEGL headers
  ];

  outputs = [ "out" "contrib" ];

  mesonFlags = [
    "-Dxwayland=${lib.boolToString withXwayland}"
    "-Dversion_override=${version}"
    "-Dman-pages=true"
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
