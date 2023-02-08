{ rustPlatform
, fetchFromGitHub
, pkg-config
, dbus
, protobuf
, lib
}:

rustPlatform.buildRustPackage rec {
  pname = "pbpctrl";

  # https://github.com/qzed/pbpctrl/issues/4
  version = "unstable-2023-02-07";

  src = fetchFromGitHub {
    owner = "qzed";
    repo = "${pname}";
    rev = "9fef4bb88046a9f00719b189f8e378c8dbdb8ee6";
    hash = "sha256-8YbsBqqITJ9bKzbGX6d/CSBb8wzr6bDzy8vsyntL1CA=";
  };

  cargoHash = "sha256-ZxJjjaT/ZpEPxvO42UWBy3xW/V5dhXGsKn3KmuM89YA==";

  nativeBuildInputs = [ pkg-config protobuf ];
  buildInputs = [ dbus ];

  meta = with lib; {
    description = "Control Google Pixel Buds Pro from the Linux command line.";
    homepage = "https://github.com/qzed/pbpctrl";
    license = with licenses; [ asl20 mit ];
    maintainers = [ maintainers.vanilla ];
    platforms = platforms.linux;
  };
}
