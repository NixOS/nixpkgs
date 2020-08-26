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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "federico-terzi";
    repo = pname;
    rev = "v${version}";
    sha256 = "11xdnn1iwpx58s3wvjb6dkgfc6dzsblzb6fngc0np5vx8r2pccpg";
  };

  cargoSha256 = "1yjpqjfrixscg52yhalybgp734w3sdqg5hxka8ppcvz7lp3w5b1s";

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
