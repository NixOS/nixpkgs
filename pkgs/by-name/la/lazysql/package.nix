{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, xorg ? null
, darwin ? null
}:

buildGoModule rec {
  pname = "lazysql";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "jorgerojas26";
    repo = "lazysql";
    rev = "v${version}";
    hash = "sha256-QzvaQMSr0PjeAGJr5ThAQ/U0dRMa17E5hiPnc2ViUNo=";
  };

  vendorHash = "sha256-celee8uyoirX+vtAww2iQJtRwJEHyfHL2mZA2muSRiQ=";

  buildInputs = lib.optionals stdenv.isLinux [ xorg.libX11 ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Cocoa ];

  meta = with lib; {
    description = "A cross-platform TUI database management tool written in Go";
    homepage = "https://github.com/jorgerojas26/lazysql";
    license = licenses.mit;
    maintainers = with maintainers; [ kanielrkirby ];
    mainProgram = "lazysql";
  };
}
