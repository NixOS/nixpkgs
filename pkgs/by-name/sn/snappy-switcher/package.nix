{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  wayland-scanner,
  makeWrapper,
  wayland,
  wayland-protocols,
  cairo,
  pango,
  json_c,
  libxkbcommon,
  glib,
  librsvg,
  gdk-pixbuf,
  coreutils,
  gnugrep,
  gnused,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "snappy-switcher";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "OpalAayan";
    repo = "snappy-switcher";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yc9oQcEqbnx9GJhNiuvNT9ueUxFAYzQu4WKB9F+ywkE=";
  };

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
    makeWrapper
  ];

  buildInputs = [
    wayland
    wayland-protocols
    cairo
    pango
    json_c
    libxkbcommon
    glib
    librsvg
    gdk-pixbuf
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/snappy-switcher/themes
    mkdir -p $out/share/doc/snappy-switcher

    install -m 755 snappy-switcher $out/bin/
    install -m 644 themes/*.ini $out/share/snappy-switcher/themes/
    install -m 644 config.ini.example $out/share/doc/snappy-switcher/
    install -m 644 README.md $out/share/doc/snappy-switcher/

    # Install and wrap scripts
    install -m 755 scripts/snappy-wrapper.sh $out/bin/snappy-wrapper
    wrapProgram $out/bin/snappy-wrapper \
      --prefix PATH : ${lib.makeBinPath [ coreutils gnugrep gnused ]}

    install -m 755 scripts/install-config.sh $out/bin/snappy-install-config
    wrapProgram $out/bin/snappy-install-config \
      --prefix PATH : ${lib.makeBinPath [ coreutils gnugrep gnused ]}

    runHook postInstall
  '';

  meta = {
    description = "Fast, animated Alt+Tab window switcher for Hyprland";
    homepage = "https://github.com/OpalAayan/snappy-switcher";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [OpalAayan];
    mainProgram = "snappy-switcher";
  };
})
