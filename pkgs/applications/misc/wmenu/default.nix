{ lib
, stdenv
, fetchFromSourcehut
, fetchpatch
, pkg-config
, meson
, ninja
, cairo
, pango
, wayland
, wayland-protocols
, libxkbcommon
, scdoc
}:

stdenv.mkDerivation rec {
  pname = "wmenu";
<<<<<<< HEAD
  version = "0.1.4";
=======
  version = "0.1.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  strictDeps = true;

  src = fetchFromSourcehut {
    owner = "~adnano";
    repo = "wmenu";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-aB23wi8kLBKAvQv2UPsfqVMCjakdsM6AzH8LgGv3HPs=";
  };

=======
    hash = "sha256-mS4qgf2sjgswasZXsmnbIWlqVv+Murvx1/ob0G3xsws=";
  };

  # Patch needed to remove build warning, gets merged in next release
  patches = [
    (fetchpatch {
      url = "https://git.sr.ht/~adnano/wmenu/commit/ba10072cdec9b0d4b51bcf305ff27dcf3003ae42.patch";
      hash = "sha256-XF7xmEnsKlExMJQ5iS7wQG9Ja6ocrR0YvQuWFfByKVA=";
    })
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [ pkg-config meson ninja ];
  buildInputs = [ cairo pango wayland libxkbcommon wayland-protocols scdoc ];

  meta = with lib; {
    description = "An efficient dynamic menu for Sway and wlroots based Wayland compositors";
    homepage = "https://git.sr.ht/~adnano/wmenu";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ eken ];
  };
}

