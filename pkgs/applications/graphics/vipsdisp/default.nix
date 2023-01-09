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
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "jcupitt";
    repo = "vipsdisp";
    rev = "v${version}";
    sha256 = "sha256-zftvjH5hyWBpjRe5uQBDAqbThQaQFHz0UhzM5q8hSk8=";
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
    maintainers = with maintainers; [ foo-dogsquared ];
  };
}
