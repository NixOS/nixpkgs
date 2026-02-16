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
  libxtst,
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
    x86_64-linux = "linux-x86_64";
    aarch64-linux = "linux-arm64";
  };

  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";

  arch = mozillaPlatforms.${stdenv.hostPlatform.system} or throwSystem;

  policies = config.librewolf.policies or { };

  policiesJson = writeText "librewolf-policies.json" (builtins.toJSON { inherit policies; });

  pname = "librewolf-bin-unwrapped";

  version = "147.0.3-2";
in

stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://codeberg.org/api/packages/librewolf/generic/librewolf/${version}/librewolf-${version}-${arch}-package.tar.xz";
    hash =
      {
        x86_64-linux = "sha256-BBrZUlbA569mktjDMayR4Nb05ilhbsANKZ6yY2jZZ34=";
        aarch64-linux = "sha256-m4EkgutlR3QgEDVgtKmYkVvj7jzaZjl0cn2X4UJ6GJg=";
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
    libxtst
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
    knownVulnerabilities = [
      "librewolf-bin lacks maintenance in nixpkgs, consider using an alternative"
    ];
  };
}
