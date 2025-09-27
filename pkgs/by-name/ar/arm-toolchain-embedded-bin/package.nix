{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  zlib,
  nix-update-script,
  useOverlay ? null, # Add an argument to select a C library overlay
}:

let
  version = "21.1.0";
  pname = "arm-toolchain-for-embedded-bin";
  source =
    {
      "x86_64-linux" = {
        url = "https://github.com/arm/arm-toolchain/releases/download/release-${version}-ATfE/ATfE-${version}-Linux-x86_64.tar.xz";
        sha256 = "0vhwsilkl0sjwxmwk5mxc4k32h7jczx3j296wgyznms0dr19rda0";
        sourceRootName = "ATfE-${version}-Linux-x86_64";
      };
      "aarch64-linux" = {
        url = "https://github.com/arm/arm-toolchain/releases/download/release-${version}-ATfE/ATfE-${version}-Linux-aarch64.tar.xz";
        sha256 = "0s8xsnvallcclbxmq0m24axwabkvhnzg8fz76lmryrgz6z29m5h4";
        sourceRootName = "ATfE-${version}-Linux-aarch64";
      };
    }
    .${stdenv.system};

  overlaySource =
    if useOverlay == null then
      null
    else
      {
        "llvmlibc" = {
          url = "https://github.com/arm/arm-toolchain/releases/download/release-${version}-ATfE/ATfE-llvmlibc-overlay-${version}.tar.xz";
          sha256 = "0l49dmha8hg4i1zgzv8lrq1769pfv7223h7yn6nb44qqbgsiyk9h";
        };
        "newlib" = {
          url = "https://github.com/arm/arm-toolchain/releases/download/release-${version}-ATfE/ATfE-newlib-overlay-${version}.tar.xz";
          sha256 = "0da205sanpjvplm45wk0qrjgaq1j8jfi7j337388lca4dwg02yj5";
        };
        "newlib-nano" = {
          url = "https://github.com/arm/arm-toolchain/releases/download/release-${version}-ATfE/ATfE-newlib-nano-overlay-${version}.tar.xz";
          sha256 = "10r659809gcmpy7h73a5lx5mzziq2cppvq7nhywa44m58yhzlywq";
        };
      }
      .${useOverlay};
in

stdenv.mkDerivation rec {
  inherit pname version;
  src = fetchurl { inherit (source) url sha256; };
  overlaySrc = if overlaySource == null then null else fetchurl overlaySource;

  outputs = [
    "out"
    "doc"
    "samples"
  ];

  dontBuild = true;

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [
    stdenv.cc.cc
    zlib
  ];

  assertions = [
    (lib.asserts.assertOneOf "useOverlay" useOverlay [
      null
      "llvmlibc"
      "newlib"
      "newlib-nano"
    ])
  ];

  installPhase = ''
    runHook preInstall

    # 1. Copy all base files to $out
    mkdir -p $out
    cp -a ./* $out/

  ''
  + lib.optionalString (overlaySrc != null) ''
    # 2. Apply overlay on top of $out, if selected
    echo "Applying '${useOverlay}' overlay by extracting on top of $out..."
    tar xf ${overlaySrc} -C $out
  ''
  + ''
    # 3. Now that $out is a complete merge, move non-core parts out of it.
    # Create destination directories
    mkdir -p $doc/share/doc/${pname}
    mkdir -p $out/share/licenses/${pname}

    # Move docs
    mv $out/docs $out/CHANGELOG.md $out/README.md $out/VERSION.txt $out/ATfE-SBOM.spdx.json $doc/share/doc/${pname}/
    # Also move the overlay SBOM file if it exists
    mv $out/ATfE-SBOM-*-overlay.spdx.json $doc/share/doc/${pname}/ 2>/dev/null || true

    # Move licenses
    mv $out/LICENSE.txt $out/THIRD-PARTY-LICENSES.txt $out/third-party-licenses $out/share/licenses/${pname}/

    # Move samples if they exist
    if [ -d "$out/samples" ]; then
      mkdir -p $samples/share/samples/${pname}
      mv $out/samples $samples/share/samples/${pname}/
    fi

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Arm Toolchain for Embedded (ATfE) binary, with optional C library overlays.";
    homepage = "https://www.arm.com/products/development-tools/embedded/arm-toolchain-for-embedded";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = [
      lib.licenses.asl20
      lib.licenses.llvm-exception
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [ eihqnh ];
  };
}
