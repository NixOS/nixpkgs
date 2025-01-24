{
  lib,
  rustPlatform,
  fetchFromGitHub,
  dbus,
  gdk-pixbuf,
  libnotify,
  makeWrapper,
  pkg-config,
  xorg,
  enableAlsaUtils ? true,
  alsa-utils,
  coreutils,
  enableNetwork ? true,
  dnsutils,
  iproute2,
  wirelesstools,
}:

let
  bins =
    lib.optionals enableAlsaUtils [
      alsa-utils
      coreutils
    ]
    ++ lib.optionals enableNetwork [
      dnsutils
      iproute2
      wirelesstools
    ];
in

rustPlatform.buildRustPackage rec {
  pname = "dwm-status";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "Gerschtli";
    repo = pname;
    rev = version;
    sha256 = "sha256-GkTPEmsnHFLUvbasAOXOQjFKs1Y9aaG87uyPvnQaT8Y=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];
  buildInputs = [
    dbus
    gdk-pixbuf
    libnotify
    xorg.libX11
  ];

  cargoHash = "sha256-eRfXUnyzOfVSEiwjLCaNbETUPXVU2Ed2VUNM9FjS5YE=";

  postInstall = lib.optionalString (bins != [ ]) ''
    wrapProgram $out/bin/dwm-status --prefix "PATH" : "${lib.makeBinPath bins}"
  '';

  meta = with lib; {
    description = "Highly performant and configurable DWM status service";
    homepage = "https://github.com/Gerschtli/dwm-status";
    changelog = "https://github.com/Gerschtli/dwm-status/blob/master/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ gerschtli ];
    mainProgram = "dwm-status";
    platforms = platforms.linux;
  };
}
