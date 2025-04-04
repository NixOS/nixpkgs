{
  lib,
  buildGoModule,
  fetchFromGitHub,

  libGL,
  libX11,
  libXcursor,
  libXinerama,
  libXi,
  libXrandr,
  libXxf86vm,
  pkg-config,
  stdenv,
  darwin,
}:

buildGoModule rec {
  pname = "fyne";
  version = "2.5.5";

  src = fetchFromGitHub {
    owner = "fyne-io";
    repo = "fyne";
    tag = "v${version}";
    hash = "sha256-cttw4Al7zn7hlKu8n7by+m2p9Xm7ZoCtMb9VuAFdP6k=";
  };

  vendorHash = "sha256-X6K7IV+yjKXw/1A5HikS0T8rtrn7gLZM2d0VoyIdOT4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [
      libGL
      libX11
      libXcursor
      libXinerama
      libXi
      libXrandr
      libXxf86vm
    ]
    ++ (lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk_11_0.frameworks;
      [
        Carbon
        Cocoa
        Kernel
        UserNotifications
      ]
    ));

  doCheck = false;

  meta = with lib; {
    homepage = "https://fyne.io";
    description = "Cross platform GUI toolkit in Go";
    license = licenses.bsd3;
    maintainers = with maintainers; [ greg ];
    mainProgram = "fyne";
  };
}
