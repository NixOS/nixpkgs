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
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "fyne-io";
    repo = "fyne";
    rev = "refs/tags/v${version}";
    hash = "sha256-XaD7t1hSv5plDa6QHDTyoWgzvSFMRezvHl47YphXoig=";
  };

  vendorHash = "sha256-uV+pbGxAV/uuHV0xl2vPZpgGYRj9/E0rhFtLfCV5rnE=";

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
