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
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "federico-terzi";
    repo = pname;
    rev = "v${version}";
    sha256 = "11b02i254dn5nwk8m2g21ixz22qcqgcf90vwll0n3yny78p40hn0";
  };

  cargoSha256 = "1cnz6rbqbb08j67bw485qi22pi31b3l3yzgr6w1qx780ldf1zd54";

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
