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
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "federico-terzi";
    repo = pname;
    rev = "v${version}";
    sha256 = "1yspycgmg7vwf4d86r6n24lvgn14aq73fl8sn00shxndramp46ib";
  };

  cargoSha256 = "0g0xf8j4yjayl7a5sqxm3piiif1hc7ws3i7q8vi7dk8nk609pbxr";

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

    longDescription = ''
      Espanso detects when you type a keyword and replaces it while you're typing.
    '';
  };
}
