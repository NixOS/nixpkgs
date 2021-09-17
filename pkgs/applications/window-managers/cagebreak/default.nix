{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cairo
, fontconfig
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
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "project-repo";
    repo = pname;
    rev = version;
    hash = "sha256-1IztedN5/I/4TDKHLJ26fSrDsvJ5QAr+cbzS2PQITDE=";
  };

  patches = [
    # To fix the build with wlroots 0.14.0:
    (fetchpatch {
      # Add fixes for wlroots 0.14.0
      url = "https://github.com/project-repo/cagebreak/commit/d57869d43add58331386fc8e89c14bb2b74afe17.patch";
      sha256 = "0g6sl8y4kk0bm5x6pxqbxw2j0gyg3ybr2v9m70q2pxp70kms4lqg";
    })
  ];

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
    wrapProgram $out/bin/cagebreak --prefix PATH : "${xwayland}/bin"
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
