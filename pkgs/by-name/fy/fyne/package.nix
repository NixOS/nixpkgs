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
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "fyne-io";
    repo = "fyne";
    rev = "refs/tags/v${version}";
    hash = "sha256-DUXCaPFMb6f7ROI8DC2RVCX12xf5F9MEtBJyi8CuoE4=";
  };

  vendorHash = "sha256-Mz+p2kpPtqFb/wDkwOdIUQ2fCvzWqTH49YRjWmSlF4M=";

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
    ++ (lib.optionals stdenv.isDarwin (
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
