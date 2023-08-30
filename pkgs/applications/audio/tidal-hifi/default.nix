{ lib
, buildNpmPackage
, fetchFromGitHub
, writeText
, autoPatchelfHook
, makeWrapper
, callPackage
, alsa-lib
, at-spi2-atk
, at-spi2-core
, atk
, cairo
, cups
, dbus
, expat
, ffmpeg
, fontconfig
, freetype
, gdk-pixbuf
, glib
, gtk3
, libappindicator-gtk3
, libdbusmenu
, libdrm
, libnotify
, libpulseaudio
, libsecret
, libuuid
, libxkbcommon
, mesa
, nss
, pango
, systemd
, xdg-utils
, xorg
}:

let
  deps = callPackage ./deps { };
in
buildNpmPackage rec {
  pname = "tidal-hifi";
  version = "5.7.0";

  src = fetchFromGitHub {
    owner = "Mastermindzh";
    repo = pname;
    rev = version;
    hash = "sha256-uZCZDnD1xJm5YrHiJ9U3+SuREpLfCLD3wCIkfoS9g+Q=";
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    ffmpeg
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    pango
    systemd
    mesa # for libgbm
    nss
    libuuid
    libdrm
    libnotify
    libsecret
    libpulseaudio
    libxkbcommon
    libappindicator-gtk3
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libxshmfence
    xorg.libXtst
  ];

  runtimeDependencies =
    [ (lib.getLib systemd) libnotify libdbusmenu xdg-utils ];

  # set -x
  # ${jq} \
  #   '.devDependencies.electron = "path:${electronSrc}"' \
  #   package.json > package.json.new
  # ${jq} \
  #   '.packages."".devDependencies.electron = "path:${electronSrc}"' \
  #   package-lock.json > package-lock.json.new

  # mv package.json.new package.json
  # mv package-lock.json.new package-lock.json

  patches = [
    ./package-lock.json.patch
  ];

  npmDepPath_electron = "${deps.electron}/lib/node_modules/electron";
  npmDepPath_register-scheme = "${deps.register-scheme}/lib/node_modules/register-scheme";
  postPatch = ''
    substituteAllInPlace package-lock.json
  '';
  npmDepsHash = "sha256-fHo8aW6tMOyev9akhENlxpxuAGZ0q4MR+FW9WrM7YmU=";

  # ELECTRON_OVERRIDE_DIST_PATH = "${deps.electron_24-bin}/bin/";

  npmBuildScript = "build-unpacked";

  # installPhase = ''
  #   runHook preInstall

  #   mkdir -p "$out/bin"
  #   cp -R "opt" "$out"
  #   cp -R "usr/share" "$out/share"
  #   chmod -R g-w "$out"

  #   runHook postInstall
  # '';

  # postFixup = ''
  #   makeWrapper $out/opt/tidal-hifi/tidal-hifi $out/bin/tidal-hifi \
  #     --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}" \
  #     --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
  #     "''${gappsWrapperArgs[@]}"
  #   substituteInPlace $out/share/applications/tidal-hifi.desktop \
  #     --replace "/opt/tidal-hifi/tidal-hifi" "tidal-hifi"
  # '';

  meta = {
    changelog = "https://github.com/Mastermindzh/tidal-hifi/releases/tag/${version}";
    description = "The web version of Tidal running in electron with hifi support thanks to widevine";
    homepage = "https://github.com/Mastermindzh/tidal-hifi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qbit spikespaz ];
    platforms = lib.platforms.linux;
    mainProgram = "tidal-hifi";
  };
}
