{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, xorg ? null
, darwin ? null
}:

buildGoModule rec {
  pname = "lazysql";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "jorgerojas26";
    repo = "lazysql";
    rev = "v${version}";
    hash = "sha256-Pzx9wjuPv7k0q+ads/uKrRTEAZbktf4ciyD7KZjYGwQ=";
  };

  vendorHash = "sha256-hYkSdFmzljhjsh2stXWGDLHwB4NXeKQyjiN2DqG0GRg=";

  buildInputs = lib.optionals stdenv.isLinux [ xorg.libX11 ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Cocoa ];

  meta = with lib; {
    description = "A cross-platform TUI database management tool written in Go";
    homepage = "https://github.com/jorgerojas26/lazysql";
    license = licenses.mit;
    maintainers = with maintainers; [ kanielrkirby ];
    mainProgram = "lazysql";
  };
}
