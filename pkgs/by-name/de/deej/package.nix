{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  gtk3,
  libappindicator-gtk3,
  webkitgtk_4_1,
}:

buildGoModule {
  pname = "deej";
  version = "0.9.10";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "omriharel";
    repo = "deej";
    rev = "v0.9.10";
    hash = "sha256-T6S3FQ9vxl4R3D+uiJ83z1ueK+3pfASEjpRI+HjIV0M=";
  };

  vendorHash = "sha256-1gjFPD7YV2MTp+kyC+hsj+NThmYG3hlt6AlOzXmEKyA=";

  subPackages = [ "cmd" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gtk3
    libappindicator-gtk3
    webkitgtk_4_1
  ];

  preBuild = ''
    # getlantern/systray hardcodes webkit2gtk-4.0
    for file in $(grep -rl "webkit2gtk-4.0" .); do
      substituteInPlace "$file" --replace-fail "webkit2gtk-4.0" "webkit2gtk-4.1"
    done
  '';

  postInstall = ''
    mv $out/bin/cmd $out/bin/deej
  '';

  meta = with lib; {
    description = "Open-source hardware volume mixer for Windows and Linux";
    longDescription = ''
      deej is an open-source hardware volume mixer for Windows and Linux.
      It lets you use real-world sliders (potentiometers) to control the
      volume of individual apps (like Discord, Spotify and Games) independently.
    '';
    homepage = "https://github.com/omriharel/deej";
    license = lib.licenses.mit;
    maintainers = with maintainers; [ swaggeroo ];
    platforms = platforms.linux;
    mainProgram = "deej";
  };
}
