{ fetchFromGitHub
, glib
, gtk3
, openssl
, pkg-config
, python3
, rustPlatform
, lib
, wrapGAppsHook
}:

rustPlatform.buildRustPackage rec {
  pname = "break-time";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "cdepillabout";
    repo  = "break-time";
    rev = "v${version}";
    sha256 = "18p9gfp0inbnjsc7af38fghyklr7qnl2kkr25isfy9d5m8cpxqc6";
  };

  cargoSha256 = "1apkqplyd7zwc5mxnnhf00xk9ifllp1qanh37x68rgj1832k0q73";

  nativeBuildInputs = [
    pkg-config
    python3 # needed for Rust xcb package
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    openssl
  ];

  meta = with lib; {
    description = "Break timer that forces you to take a break";
    homepage    = "https://github.com/cdepillabout/break-time";
    license     = with licenses; [ mit ];
    maintainers = with maintainers; [ cdepillabout ];
    platforms   = platforms.linux;
  };
}

