{ stdenv
, fetchFromGitHub
, rustPlatform
, pkgconfig
, extra-cmake-modules
, libX11
, libXi
, libXtst
, libnotify
, openssl
, xclip
, xdotool
}:

rustPlatform.buildRustPackage rec {
  pname = "espanso";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "federico-terzi";
    repo = pname;
    rev = "v${version}";
    sha256 = "1x5p7hniapggqd18rx26mjvdf33z7rm7zz5vsqm2siv3mcl19033";
  };

  cargoSha256 = "0liwwdncymjql5dw7rwhhimcr7qdbyvfgmsd0bawvi0ym7m1v408";

  nativeBuildInputs = [
    extra-cmake-modules
    pkgconfig
  ];

  buildInputs = [
    libX11
    libXtst
    libXi
    libnotify
    openssl
    xdotool
  ];

  # Some tests require networking
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Cross-platform Text Expander written in Rust";
    homepage = "https://espanso.org";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kimat ];
    platforms = platforms.all;

    longDescription = ''
      Espanso detects when you type a keyword and replaces it while you're typing.
    '';
  };
}
