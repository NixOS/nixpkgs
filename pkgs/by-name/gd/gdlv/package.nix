{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  AppKit,
  CoreGraphics,
  Foundation,
  Metal,
}:
buildGoModule rec {
  pname = "gdlv";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "aarzilli";
    repo = "gdlv";
    rev = "v${version}";
    hash = "sha256-6NU7bhURdXM4EjVnsXVf9XFOUgHyVEI0kr15q9OnUTQ=";
  };

  vendorHash = null;
  subPackages = ".";

  preBuild =
    lib.optionalString
      (stdenv.hostPlatform.isDarwin && lib.versionOlder stdenv.hostPlatform.darwinMinVersion "11.0")
      ''
        export MACOSX_DEPLOYMENT_TARGET=10.15
      '';

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    AppKit
    CoreGraphics
    Foundation
    Metal
  ];

  meta = with lib; {
    description = "GUI frontend for Delve";
    mainProgram = "gdlv";
    homepage = "https://github.com/aarzilli/gdlv";
    maintainers = with maintainers; [ mmlb ];
    license = licenses.gpl3;
  };
}
