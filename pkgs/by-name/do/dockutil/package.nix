{
  lib,
  stdenv,
  stdenvNoCC,
  fetchFromGitHub,
  fetchurl,
  swift,
  swiftpm,
  swiftpm2nix,
  swiftPackages,
  libarchive,
  p7zip,
  # Building from source on x86_64 fails (among other things) due to:
  # error: cannot load underlying module for 'Darwin'
  fromSource ? (stdenv.system != "x86_64-darwin"),
}:

let
  generated = swiftpm2nix.helpers ./generated;

  pname = "dockutil";
  version = "3.1.3";

  meta = with lib; {
    description = "Tool for managing dock items";
    homepage = "https://github.com/kcrawford/dockutil";
    license = licenses.asl20;
    maintainers = with maintainers; [ tboerger ];
    mainProgram = "dockutil";
    platforms = platforms.darwin;
  };

  buildFromSource = swiftPackages.stdenv.mkDerivation (finalAttrs: {
    inherit pname version meta;

    src = fetchFromGitHub {
      owner = "kcrawford";
      repo = "dockutil";
      rev = finalAttrs.version;
      hash = "sha256-mmk4vVZhq4kt05nI/dDM1676FDWyf4wTSwY2YzqKsLU=";
    };

    postPatch = ''
      # Patch sources so that they build with Swift CoreFoundation
      # which differs ever so slightly from Apple's implementation.
      substituteInPlace Sources/DockUtil/DockUtil.swift \
        --replace-fail "URL(filePath:" \
                       "URL(fileURLWithPath:" \
        --replace-fail "path(percentEncoded: false)" \
                       "path"
    '';

    nativeBuildInputs = [
      swift
      swiftpm
    ];

    configurePhase = generated.configure;

    installPhase = ''
      runHook preInstall
      install -Dm755 .build/${stdenv.hostPlatform.darwinArch}-apple-macosx/release/dockutil -t $out/bin
      runHook postInstall
    '';
  });

  installBinary = stdenvNoCC.mkDerivation (finalAttrs: {
    inherit pname version;

    src = fetchurl {
      url = "https://github.com/kcrawford/dockutil/releases/download/${finalAttrs.version}/dockutil-${finalAttrs.version}.pkg";
      hash = "sha256-9g24Jz/oDXxIJFiL7bU4pTh2dcORftsAENq59S0/JYI=";
    };

    dontPatch = true;
    dontConfigure = true;
    dontBuild = true;

    nativeBuildInputs = [
      libarchive
      p7zip
    ];

    unpackPhase = ''
      7z x $src
      bsdtar -xf Payload~
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      install -Dm755 usr/local/bin/dockutil -t $out/bin
      runHook postInstall
    '';

    meta = meta // {
      sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    };
  });
in
if fromSource then buildFromSource else installBinary
