{
  lib,
  appimageTools,
  fetchurl,
  makeWrapper,
}:
let
  pname = "bazecor";
  version = "1.10.0";
  src = appimageTools.extract {
    inherit pname version;
    src = fetchurl {
      url = "https://github.com/Dygmalab/Bazecor/releases/download/v${version}/Bazecor-${version}-x64.AppImage";
      hash = "sha256-tdkuZ7YIdHetdLi5EUk9HMvW0mW0Oqsb28xseises2Q=";
    };

    # Workaround for https://github.com/Dygmalab/Bazecor/issues/370
    # 1.10.0 refactored checkUdev (reads file `f`, compares to rules text `h`);
    # with the bound-mount based FHS sandbox the udev rules file is never at the
    # expected location, so keep the check bypassed.
    postExtract = ''
      substituteInPlace \
        $out/usr/lib/bazecor/resources/app/.webpack/main/index.js \
        --replace-fail \
          'checkUdev=()=>{try{if(l.default.existsSync(f))return l.default.readFileSync(f,"utf-8").trim()===h.trim()}catch(e){d.default.error(e)}return!1}' \
          'checkUdev=()=>{return 1}'
    '';
  };
in
appimageTools.wrapAppImage {
  inherit pname version src;

  # also make sure to update the udev rules in ./60-dygma.rules; most recently
  # taken from
  # https://github.com/Dygmalab/Bazecor/blob/v1.4.4/src/main/utils/udev.ts#L6

  nativeBuildInputs = [ makeWrapper ];

  # udevadm must live inside the sandbox, otherwise Bazecor's device enumeration
  # "find keyboard" fails with `spawn udevadm ENOENT` and Dygma keyboards are not
  # detected at all.
  extraPkgs = pkgs: [
    pkgs.glib
    pkgs.systemdMinimal
  ];

  # Also expose the udev rules here, so it can be used as:
  #   services.udev.packages = [ pkgs.bazecor ];
  # to allow non-root modifications to the keyboards.

  extraInstallCommands = ''
    wrapProgram $out/bin/bazecor \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    install -m 444 -D ${src}/Bazecor.desktop -t $out/share/applications
    install -m 444 -D ${src}/bazecor.png -t $out/share/icons/hicolor/512x512/apps

    mkdir -p $out/lib/udev/rules.d
    install -m 444 -D ${./60-dygma.rules} $out/lib/udev/rules.d/60-dygma.rules

    substituteInPlace $out/share/applications/Bazecor.desktop \
      --replace-fail 'Exec=Bazecor' 'Exec=bazecor'
  '';

  meta = {
    description = "Graphical configurator for Dygma Products";
    homepage = "https://github.com/Dygmalab/Bazecor";
    changelog = "https://github.com/Dygmalab/Bazecor/releases/tag/v${version}";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      gcleroux
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "bazecor";
  };
}
