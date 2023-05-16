{ lib
, stdenv
, fetchFromGitLab
<<<<<<< HEAD
=======
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, meson
, ninja
, pkg-config
, rustPlatform
, rustc
, cargo
, wrapGAppsHook4
, blueprint-compiler
, libadwaita
, libsecret
, tracker
, darwin
}:

stdenv.mkDerivation rec {
  pname = "health";
<<<<<<< HEAD
  version = "0.95.0";
=======
  version = "0.94.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-PrNPprSS98yN8b8yw2G6hzTSaoE65VbsM3q7FVB4mds=";
=======
    hash = "sha256-KS0sdCQg2LqQB0K1cUbAjA8VITn5rAb8XCWjOKYbPqM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
<<<<<<< HEAD
    name = "${pname}-${version}";
    hash = "sha256-8fa3fa+sFi5H+49B5sr2vYPkp9C9s6CcE0zv4xB8gww=";
  };

=======
    patches = [ ./update_gtk4_cargo_deps.patch ];
    name = "${pname}-${version}";
    hash = "sha256-j0I0vKoGaf2pce2C/xkz+nJYCfLvHB5F6Q9XpJtABMI=";
  };

  patches = [
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/max_size_tightending_thresh_0.94.0.patch?h=health&id=d35d89760964b00ad457eca07855143a1dcbabdf";
      hash = "sha256-ndoxyrm+SVGVxfUbc5sQItQwzK75ZtKMSGUOB9mzBmo=";
    })
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/max_value_0.94.0.patch?h=health&id=d35d89760964b00ad457eca07855143a1dcbabdf";
      hash = "sha256-YKVQNtz+RWN6Ydw+kbStCVf0vu0eTrMKGd6kEijFG00=";
    })
    # patch both or it will complain Cargo.lock mismatch
    ./update_gtk4_cargo_deps.patch
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    cargo
    wrapGAppsHook4
    blueprint-compiler
  ];

  buildInputs = [
    libadwaita
    libsecret
    tracker
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.Foundation
  ];

  meta = with lib; {
    description = "A health tracking app for the GNOME desktop";
    homepage = "https://apps.gnome.org/app/dev.Cogitri.Health";
    license = licenses.gpl3Plus;
    mainProgram = "dev.Cogitri.Health";
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.unix;
  };
}
