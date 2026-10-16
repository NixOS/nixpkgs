{
  stdenv,
  lib,
  fetchurl,
  fetchFromGitHub,
  cmake,
  pkg-config,
  capnproto,
  sqlite,
  boost,
  zlib,
  rapidjson,
  pandoc,
}:
let
  js.vue = fetchurl {
    url = "https://cdnjs.cloudflare.com/ajax/libs/vue/2.6.12/vue.min.js";
    sha256 = "1hm5kci2g6n5ikrvp1kpkkdzimjgylv1xicg2vnkbvd9rb56qa99";
  };
  js.ansi_up = fetchurl {
    url = "https://raw.githubusercontent.com/drudru/ansi_up/v5.2.1/ansi_up.js";
    hash = "sha256-n+tjM7z62ovMht6Zud3jfyQvgrO6cL9zdyEBakKuuRs=";
  };
  js.Chart = fetchurl {
    url = "https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js";
    hash = "sha256-+8RZJua0aEWg+QVVKg4LEzEEm/8RFez5Tb4JBNiV5xA=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "laminar";
  version = "1.4";
  outputs = [
    "out"
    "doc"
  ];
  src = fetchFromGitHub {
    owner = "ohwgiles";
    repo = "laminar";
    rev = finalAttrs.version;
    hash = "sha256-epaiwaQkVohUEDUZNzUxWcOoJ+CxEUlJ8lX2C7e9vWo=";
  };
  patches = [ ./patches/no-network.patch ];

  # We need both binary from "capnproto" and library files.
  nativeBuildInputs = [
    cmake
    pkg-config
    pandoc
    capnproto
  ];
  buildInputs = [
    capnproto
    sqlite
    boost
    zlib
    rapidjson
  ];
  cmakeFlags = [ "-DLAMINAR_VERSION=${finalAttrs.version}" ];

  preBuild = ''
    mkdir -p js css
    cp  ${js.vue}         js/vue.min.js
    cp  ${js.ansi_up}     js/ansi_up.js
    cp  ${js.Chart}       js/Chart.min.js
  '';

  postInstall = ''
    mv $out/usr/share/* $out/share/
    rmdir $out/usr/share $out/usr

    mkdir -p $out/share/doc/laminar
    pandoc -s ../UserManual.md -o $out/share/doc/laminar/UserManual.html
    rm -rf $out/lib # remove upstream systemd units
    rm -rf $out/etc # remove upstream config file
  '';

  meta = {
    description = "Lightweight and modular continuous integration service";
    homepage = "https://laminar.ohwg.net";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      kaction
      maralorn
    ];
  };
})
