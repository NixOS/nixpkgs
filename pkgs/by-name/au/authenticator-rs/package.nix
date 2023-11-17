{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, rustPlatform
, glib
, gtk3
, meson
, ninja
, openssl
, pkg-config
, sqlite
, libxml2 # for xmllint
, wrapGAppsHook
}:

rustPlatform.buildRustPackage rec {
  pname = "authenticator-rs";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "grumlimited";
    repo = "authenticator-rs";
    rev = version;
    sha256 = "sha256-zof+RMjp1y8pizWgBm+GYrHOyvAe2et3nGLO4hZ8/+o=";
  };

  cargoSha256 = "sha256-RWT60myX3kX8xdeMLueSec3tcle/OB/Qy/QI0yZ/xYQ=";

  nativeBuildInputs = [ meson pkg-config glib libxml2 ninja wrapGAppsHook ];
  buildInputs = [ gtk3 openssl sqlite ];

  postUnpack = ''
    # The build version is actually ${version}; the source is wrong.
    # https://github.com/grumlimited/authenticator-rs/pull/139
    sed -i "s,0\.0\.1,${version}," source/meson.build source/Cargo.{toml,lock}

    # Fix paths to load from the Nix store.
    substituteInPlace source/src/main.rs --replace /usr/share $out/share
  '';

  patches = [
    # Fix Makefile to allow installing into the Nix store
    # https://github.com/grumlimited/authenticator-rs/pull/138
    (fetchpatch {
      url = "https://github.com/grumlimited/authenticator-rs/commit/42500547753cb82bea060139cd79bae96b4ffa50.patch";
      sha256 = "sha256-OPmNLM1CLS1zYxQfRDp4Tg5K3SxaOJvS1DO8F9tVAiU=";
    })
  ];

  preInstall = ''
    make install-gresource bindir=$out/bin sharedir=$out/share PREFIX=/ DESTDIR=$out
  '';

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  # `authenticator-rs` only needs Ninja for the Meson build, not for anything else.
  dontUseNinjaBuild = true;
  dontUseNinjaCheck = true;
  dontUseNinjaInstall = true;

  # Skip tests which need a network connection to download assets from the BBC (!)
  checkFlags = [
    "--skip helpers::icon_parser::tests::download"
    "--skip helpers::icon_parser::tests::html"
  ];

  meta = with lib; {
    maintainers = with maintainers; [ philiptaron ];
    description = "TOTP MFA/2FA application written in Rust and GTK3";
    license = licenses.gpl3Plus;
    homepage = "https://github.com/grumlimited/authenticator-rs";
    mainProgram = "authenticator-rs";
  };
}
