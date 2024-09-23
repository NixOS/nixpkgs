{ lib
, stdenv
, fetchFromGitLab
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
  version = "0.95.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = pname;
    rev = version;
    hash = "sha256-PrNPprSS98yN8b8yw2G6hzTSaoE65VbsM3q7FVB4mds=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-8fa3fa+sFi5H+49B5sr2vYPkp9C9s6CcE0zv4xB8gww=";
  };

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

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.cc.isClang [
    "-Wno-error=incompatible-function-pointer-types"
  ]);

  meta = with lib; {
    description = "Health tracking app for the GNOME desktop";
    homepage = "https://apps.gnome.org/app/dev.Cogitri.Health";
    license = licenses.gpl3Plus;
    mainProgram = "dev.Cogitri.Health";
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.unix;
  };
}
