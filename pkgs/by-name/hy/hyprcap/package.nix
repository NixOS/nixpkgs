{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  grim,
  hyprland,
  hyprpicker,
  libnotify,
  jq,
  slurp,
  wf-recorder,
  wl-clipboard,
  fuzzel,
  nix-update-script,
  with-clipboard ? true,
  with-hyprpicker ? true,
  with-libnotify ? true,
  menu ? fuzzel,
}:
let
  menucmd = {
    dmenu = "dmenu";
    rofi = "rofi -dmenu";
    fuzzel = "fuzzel -d";
    wofi = "wofi --dmenu";
    bemenu = "bemenu";
    tofi = "tofi";
    wmenu = "wmenu";
    walker = "walker --dmenu";
  };
in

stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;
  pname = "hyprcap";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "alonso-herreros";
    repo = "hyprcap";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qTlv4hRy9CvB+ZkNxXuxtLjDHsjiyjjooUlDFxwqQOc";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    grim
    hyprland
    jq
    slurp
    wf-recorder
    menu
  ]
  ++ lib.optionals with-clipboard [ wl-clipboard ]
  ++ lib.optionals with-hyprpicker [ hyprpicker ]
  ++ lib.optionals with-libnotify [ libnotify ];

  postPatch = ''
    substituteInPlace hyprcap \
      --replace-fail 'readonly VERSION="DEV"' 'readonly VERSION="${finalAttrs.version}"' \
      --replace-fail 'readonly DMENU_COMMAND="fuzzel -d"' 'readonly DMENU_COMMAND="${menucmd.${menu.pname}}"'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 hyprcap $out/bin/hyprcap
    wrapProgram $out/bin/hyprcap --prefix PATH : ${lib.makeBinPath finalAttrs.buildInputs}

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Utility to easily capture screenshots and screen recordings on Hyprland";
    homepage = "https://github.com/alonso-herreros/Hyprcap";
    license = lib.licenses.gpl3;
    mainProgram = "hyprcap";
    maintainers = with lib.maintainers; [
      gigahawk
    ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
})
