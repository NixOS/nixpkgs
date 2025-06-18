{
  stdenv,
  lib,
  fetchurl,
  fetchFromGitHub,
  cmake,
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
    url = "https://raw.githubusercontent.com/drudru/ansi_up/v4.0.4/ansi_up.js";
    sha256 = "1dx8wn38ds8d01kkih26fx1yrisg3kpz61qynjr4zil03ap0hrlr";
  };
  js.Chart = fetchurl {
    url = "https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js";
    hash = "sha256-+8RZJua0aEWg+QVVKg4LEzEEm/8RFez5Tb4JBNiV5xA=";
  };
in
stdenv.mkDerivation rec {
  pname = "laminar";
  version = "1.3";
  outputs = [
    "out"
    "doc"
  ];
  src = fetchFromGitHub {
    owner = "ohwgiles";
    repo = "laminar";
    rev = version;
    hash = "sha256-eo5WzvmjBEe0LAfZdQ/U0XepEE2kdWKKiyE4HOi3RXk=";
  };
  patches = [ ./patches/no-network.patch ];

  # We need both binary from "capnproto" and library files.
  nativeBuildInputs = [
    cmake
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
  cmakeFlags = [ "-DLAMINAR_VERSION=${version}" ];

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

  meta = with lib; {
    description = "Lightweight and modular continuous integration service";
    homepage = "https://laminar.ohwg.net";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      kaction
      maralorn
    ];
  };
}
