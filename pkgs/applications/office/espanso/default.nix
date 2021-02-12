{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
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
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "federico-terzi";
    repo = pname;
    rev = "v${version}";
    sha256 = "1q47r43midkq9574gl8gdv3ylvrnbhdc39rrw4y4yk6jbdf5wwkm";
  };

  cargoSha256 = "065k0ir1xpwwz9na3pbm3xr8nksrgmkydz4df3xiaqxwksjv1x94";

  nativeBuildInputs = [
    extra-cmake-modules
    pkg-config
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

  meta = with lib; {
    description = "Cross-platform Text Expander written in Rust";
    homepage = "https://espanso.org";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kimat ];

    longDescription = ''
      Espanso detects when you type a keyword and replaces it while you're typing.
    '';
  };
}
