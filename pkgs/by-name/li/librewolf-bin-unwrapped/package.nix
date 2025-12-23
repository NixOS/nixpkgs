{
  lib,
  stdenv,
  fetchurl,
  config,
  wrapGAppsHook3,
  autoPatchelfHook,
  alsa-lib,
  curl,
  dbus-glib,
  gtk3,
  libXtst,
  libva,
  pciutils,
  pipewire,
  adwaita-icon-theme,
  writeText,
  patchelfUnstable, # have to use patchelfUnstable to support --no-clobber-old-sections
}:

let
  binaryName = "librewolf";

  mozillaPlatforms = {
    i686-linux = "linux-i686";
    x86_64-linux = "linux-x86_64";
    aarch64-linux = "linux-arm64";
  };

  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";

  arch = mozillaPlatforms.${stdenv.hostPlatform.system} or throwSystem;

  policies = config.librewolf.policies or { };

  policiesJson = writeText "librewolf-policies.json" (builtins.toJSON { inherit policies; });

  pname = "librewolf-bin-unwrapped";

  version = "143.0.4-1";
in

stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://gitlab.com/api/v4/projects/44042130/packages/generic/librewolf/${version}/librewolf-${version}-${arch}-package.tar.xz";
    hash =
      {
        i686-linux = "sha256-GKdnsh7nkXlZh8QYBUhmB003IqfPI1+KxogZCxmyiUY=";
        x86_64-linux = "sha256-1ZwXfE13K8X/fhBs0ibFaM7A/bRDNbU4hpEGdZIjIRk=";
        aarch64-linux = "sha256-ICxN/7gqFlqH910DTo+cbrM1AoioY2Jbp2U8AfNxGUg=";
      }
      .${stdenv.hostPlatform.system} or throwSystem;
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    autoPatchelfHook
    patchelfUnstable
  ];

  buildInputs = [
    gtk3
    adwaita-icon-theme
    alsa-lib
    dbus-glib
    libXtst
  ];

  runtimeDependencies = [
    curl
    libva.out
    pciutils
  ];

  appendRunpaths = [ "${pipewire}/lib" ];

  # Firefox uses "relrhack" to manually process relocations from a fixed offset
  patchelfFlags = [ "--no-clobber-old-sections" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $prefix/lib $out/bin
    cp -r . $prefix/lib/librewolf-bin-${version}
    ln -s $prefix/lib/librewolf-bin-${version}/librewolf $out/bin/${binaryName}
    # See: https://github.com/mozilla/policy-templates/blob/master/README.md
    mv $out/lib/librewolf-bin-${version}/distribution/policies.json $out/lib/librewolf-bin-${version}/distribution/extra-policies.json
    ${lib.optionalString (config.librewolf.policies or false) ''
      ln -s ${policiesJson} $out/lib/librewolf-bin-${version}/distribution/policies.json
    ''}

    runHook postInstall
  '';

  passthru = {
    inherit binaryName;
    applicationName = "LibreWolf";
    libName = "librewolf-bin-${version}";
    ffmpegSupport = true;
    gssSupport = true;
    gtk3 = gtk3;
    updateScript = ./update.sh;
  };

  meta = {
    description = "Fork of Firefox, focused on privacy, security and freedom (upstream binary release)";
    homepage = "https://librewolf.net";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ dwrege ];
    platforms = builtins.attrNames mozillaPlatforms;
    mainProgram = "librewolf";
    hydraPlatforms = [ ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
