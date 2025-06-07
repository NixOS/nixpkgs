{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, xorg ? null
, darwin ? null
}:

buildGoModule rec {
  pname = "lazysql";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "jorgerojas26";
    repo = "lazysql";
    rev = "v${version}";
    hash = "sha256-AUu4mKIcwjXlvJSszeuAuPHH3pQs4+LUU6NitVEatnk=";
  };

  vendorHash = "sha256-tgD6qoCVC1ox15VPJWVvhe4yg3R81ktMuW2dsaU69rY=";

  buildInputs = lib.optionals stdenv.isLinux [ xorg.libX11 ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Cocoa ];

  meta = with lib; {
    description = "A cross-platform TUI database management tool written in Go";
    homepage = "https://github.com/jorgerojas26/lazysql";
    license = licenses.mit;
    maintainers = with maintainers; [ kanielrkirby ];
    mainProgram = "lazysql";
  };
}
