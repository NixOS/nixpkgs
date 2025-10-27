{
  lib,
  stdenv,
  fetchurl,
  callPackage,
  cpio,
  gzip,
  rsync,
  xar,
  udev,
  config,
  acceptLicense ? config.segger-jlink.acceptLicense or false,
}:

let
  source = import ./source.nix;
  supported = removeAttrs source [ "version" ];

  platform = supported.${stdenv.system} or (throw "unsupported platform ${stdenv.system}");

  inherit (source) version;

  url = "https://www.segger.com/downloads/jlink/JLink_${platform.os}_V${version}_${platform.name}.${platform.ext}";

  src =
    assert
      !acceptLicense
      -> throw ''
        Use of the "SEGGER JLink Software and Documentation pack" requires the
        acceptance of the following licenses:

          - SEGGER Downloads Terms of Use [1]
          - SEGGER Software Licensing [2]

        You can express acceptance by setting acceptLicense to true in your
        configuration. Note that this is not a free license so it requires allowing
        unfree licenses as well.

        configuration.nix:
          nixpkgs.config.allowUnfree = true;
          nixpkgs.config.segger-jlink.acceptLicense = true;

        config.nix:
          allowUnfree = true;
          segger-jlink.acceptLicense = true;

        [1]: ${url}
        [2]: https://www.segger.com/purchase/licensing/
      '';
    fetchurl {
      inherit url;
      inherit (platform) hash;
      curlOpts = "--data accept_license_agreement=accepted";
    };

  buildAttrsLinux = {
    # Udev is loaded late at runtime
    appendRunpaths = [
      "${udev}/lib"
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/opt/SEGGER/JLink

      # Install libraries
      install -Dm444 libjlinkarm.so* -t $out/lib
      for libr in $out/lib/libjlinkarm.*; do
        ln -s $libr $out/opt/SEGGER/JLink
      done

      # Install udev rules
      install -Dm444 99-jlink.rules -t $out/lib/udev/rules.d/

      runHook postInstall
    '';
  };

  buildAttrsDarwin = {
    nativeBuildInputs = [
      cpio
      gzip # gunzip
      rsync
      xar
    ];

    unpackPhase = ''
      runHook preUnpack

      xar -xf $src

      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall

      # segger package
      mkdir JLINK
      pushd JLINK
      cat ../JLink.pkg/Payload | gunzip -dc | cpio -i
      rsync -rtl ./Applications $out/
      popd

      # By default, the package unpacks a symlink to an absolute path:
      # JLink -> /Applications/SEGGER/JLink_V824
      # ... replace with a relative symlink to the package contents themselves.
      ln -rsf $out/Applications/SEGGER/{JLink_V${version},JLink}

      runHook postInstall
    '';

  };

  buildAttrs =
    if stdenv.isLinux then
      buildAttrsLinux
    else if stdenv.isDarwin then
      buildAttrsDarwin
    else
      throw "platform not supported";

in
stdenv.mkDerivation (
  finalAttrs:
  buildAttrs
  // {
    pname = "segger-jlink-headless";
    inherit src version;

    dontConfigure = true;
    dontBuild = true;

    passthru.updateScript = ./update.py;

    meta = {
      description = "Non-GUI components of the J-Link Software Suite";
      homepage = "https://www.segger.com/downloads/jlink/#J-LinkSoftwareAndDocumentationPack";
      changelog = "https://www.segger.com/downloads/jlink/ReleaseNotes_JLink.html";
      license = lib.licenses.unfree;
      platforms = lib.attrNames supported;
      maintainers = with lib.maintainers; [
        FlorianFranzen
        h7x4
        stargate01
      ];
    };
  }
)
