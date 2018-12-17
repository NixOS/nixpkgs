{ stdenv,
  fetchFromGitHub,
  rustPlatform,
  pango,
  gdk_pixbuf,
  pkgconfig,
  qtbase
}:

rustPlatform.buildRustPackage rec {
  name = "rendersvg-${version}";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = "resvg";
    rev = "v${version}";
    sha256 = "1aajrs6alcm8l9b89w9gva6ljyhda803lmdasaw8s8ga76apb729";
  };

  cargoSha256 = "056cdpd79r6j2vh3h6k8kzlnyvhaqfsfc2igmq2riab2zjfrz1dz";

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    pango
    gdk_pixbuf
    qtbase
  ];

  buildPhase = ''
    cd tools/rendersvg/
    cargo build --release --features="qt-backend cairo-backend raqote-backend"
  '';

  installPhase = ''
    install -D ../../target/release/rendersvg $out/bin/rendersvg
  '';

  meta = with stdenv.lib; {
    description = "A SVG rendering application based on resvg";
    homepage = https://github.com/RazrFalcon/resvg/tree/master/tools/rendersvg;
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ flosse ];
    platforms = [ "x86_64-linux" ];
  };
}
