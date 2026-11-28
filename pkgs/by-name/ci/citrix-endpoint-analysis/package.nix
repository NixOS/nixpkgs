{
  buildFHSEnv,
  lib,
  requireFile,
  runCommand,
  stdenvNoCC,

  dpkg,
  gnupg,
  gpgme,
  patchelf,
  ...
}:
let
  pname = "citrix-endpoint-analysis";
  version = "26.2.3";

  unwrapped = stdenvNoCC.mkDerivation {
    name = "${pname}-${version}-unwrapped";
    inherit version;

    src = requireFile rec {
      name = "${pname}-${version}.deb";
      hash = "sha256-R2Y/l8p7g9pshOuYV9G7Y+VviSIPZtoynAw7V8f5AlQ=";

      message = ''
        In order to use Citrix Endpoint Analysis, you need to comply with the
        Citrix EULA and download the 64-bit binaries, .deb (v${version}) from:

        ${meta.homepage}

        Once you have downloaded the file, please use the following command and re-run the
        installation:

        nix-prefetch-url --name ${name} file://$PWD/nsepa.deb
      '';
    };

    strictDeps = true;
    __structuredAttrs = true;

    nativeBuildInputs = [ dpkg ];

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"/opt/Citrix
      cp -r opt/Citrix/Browser-EPA "$out"/opt/Citrix/
      rm "$out"/opt/Citrix/Browser-EPA/startnsgcepa.sh

      install -m444 -Dt "$out"/share/applications opt/Citrix/Browser-EPA/nsgcepa.desktop
      substituteInPlace "$out"/share/applications/nsgcepa.desktop \
        --replace-fail "/opt/Citrix/Browser-EPA/nsgcepa" "nsgcepa"

      runHook postInstall
    '';

    doInstallCheck = true;
    nativeInstallCheckInputs = [ gnupg ];
    installCheckPhase = ''
      runHook preInstallCheck

      export GNUPGHOME="$(mktemp -d)"
      gpg --import "$out"/opt/Citrix/Browser-EPA/pubkey.asc
      gpg --verify "$out"/opt/Citrix/Browser-EPA/LinuxClientLibrary.so{.sig,}

      runHook postInstallCheck
    '';

    inherit meta;
  };

  # nsgcepa links against libgpgme.so.11, which was shipped with `gpgme_1`.
  # `gpgme` 2.x persists the same symbol versions, so we can symlink to it.
  gpgme-compat = runCommand "libgpgme-so-11-compat" { nativeBuildInputs = [ patchelf ]; } ''
    mkdir -p "$out"/lib
    patchelf --set-soname libgpgme.so.11 \
      --output "$out"/lib/libgpgme.so.11 \
      ${lib.getLib gpgme}/lib/libgpgme.so.45
  '';

  meta = {
    description = "Citrix Endpoint Analysis client for NetScaler Gateway";
    homepage = "https://www.citrix.com/downloads/citrix-endpoint-analysis/plug-ins/EPA-Clients-Linux.html";
    license = lib.licenses.unfree;
    mainProgram = "nsgcepa";
    maintainers = with lib.maintainers; [ despsyched ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
in
buildFHSEnv {
  inherit pname version meta;

  targetPkgs =
    pkgs: with pkgs; [
      curl
      glib
      gpgme
      gpgme-compat
      gtk3
      libayatana-appindicator
      libnotify
      libproxy
      libuuid
      libx11
      libxml2_13
      libxscrnsaver
      networkmanager
      openssl
      (pugixml.override { shared = true; })
      webkitgtk_4_1
    ];

  extraBwrapArgs = [ "--ro-bind ${unwrapped}/opt /opt" ];
  runScript = "/opt/Citrix/Browser-EPA/nsgcepa";
  executableName = "nsgcepa";

  extraInstallCommands = ''
    cp -r ${unwrapped}/share "$out"/
  '';

  passthru = { inherit unwrapped; };
}
