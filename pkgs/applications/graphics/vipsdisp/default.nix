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
<<<<<<< HEAD
  version = "2.5.1";
=======
  version = "2.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jcupitt";
    repo = "vipsdisp";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-hx7daXVarV4JdxZfwnTHsuxxijCRP17gkOjicI3EFlM=";
=======
    sha256 = "sha256-zftvjH5hyWBpjRe5uQBDAqbThQaQFHz0UhzM5q8hSk8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
