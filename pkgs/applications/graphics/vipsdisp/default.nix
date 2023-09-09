{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, vips
, gtk4
, python3
}:

stdenv.mkDerivation rec {
  pname = "vipsdisp";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "jcupitt";
    repo = "vipsdisp";
    rev = "v${version}";
    hash = "sha256-iLjS3vBhdPPQNtIaM++xKekYTsr1X9f6ED2A7DYV7Lc=";
  };

  postPatch = ''
    chmod +x ./meson_post_install.py
    patchShebangs ./meson_post_install.py
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    vips
    gtk4
    python3
  ];

  # No tests implemented.
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/jcupitt/vipsdisp";
    description = "Tiny image viewer with libvips";
    license = licenses.mit;
    mainProgram = "vipsdisp";
    maintainers = with maintainers; [ foo-dogsquared ];
    platforms = platforms.unix;
  };
}
