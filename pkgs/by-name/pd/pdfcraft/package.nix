{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  rustPlatform,
  pkg-config,
  makeWrapper,
  fontconfig,
  libGL,
  libx11,
  libxcursor,
  libxi,
  libxrandr,
  libxcb,
  libxkbcommon,
  wayland,
  wayland-scanner ? null,
  vulkan-loader,
  autoAddDriverRunpath ? null,
  apple-sdk ? null,
  withCraftFonts ? true,
  withOcrModels ? true,
  defaultToXWayland ? false,
  xwayland ? null,
}:

let
  pname = "pdfcraft";
  version = "0.6.0";
  commit = "53a5880386789fc3531e54f6e6ffdef9a8e41f1a";
  buildDate = "2026-10-10";

  craftFonts = fetchFromGitHub {
    owner = "storytold";
    repo = "craft-fonts";
    rev = "8dcdacd5153e64560d109541a47d806f26f048c0";
    hash = "sha256-4E9OrthE5z39xFXpvpwn4Fn6RH3wX2sF56rZZejZT+I=";
  };

  ocrDetectionModel = fetchurl {
    url = "https://ocrs-models.s3-accelerate.amazonaws.com/text-detection.rten";
    hash = "sha256-8Vz7Vr0CxL9HiiA0OYZQSh8B4WZcKzoK1mNA8FSxtco=";
  };

  ocrRecognitionModel = fetchurl {
    url = "https://ocrs-models.s3-accelerate.amazonaws.com/text-recognition.rten";
    hash = "sha256-5ISGbUzOQDF1vY0AsSj+sIq0LiCN4w5CzZiJ2PFzWm4=";
  };

  ocrLicence = fetchurl {
    url = "https://creativecommons.org/licenses/by-sa/4.0/legalcode.txt";
    hash = "sha256-KKlSnH0LtNxR9L9cEWo9Fu8kegUvdZFGZ2jd9WP9HPU=";
  };

  runtimeLibs = lib.optionals stdenv.hostPlatform.isLinux [
    libGL
    vulkan-loader
    libxkbcommon
    wayland
    libx11
    libxcursor
    libxi
    libxrandr
    libxcb
    fontconfig
  ];

  workspacePackages = [
    "-p"
    "pdfcraft"
    "-p"
    "pdfcraft-cli"
  ];
in
rustPlatform.buildRustPackage {
  inherit pname version;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "pdfcraft";
    rev = "v${version}";
    hash = "sha256-FddJfmHevL1vwDufjFReWBlocDYZihYhiFLgMZBhiPE=";
  };

  cargoHash = "sha256-Sq2DWsBHzR/kTbiDjCcLVqLd66MF6dzUl/MtaU1EK/g=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux (
    lib.optional (wayland-scanner != null) wayland-scanner
    ++ lib.optional (autoAddDriverRunpath != null) autoAddDriverRunpath
  );

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux runtimeLibs
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk
    ];

  cargoBuildFlags = workspacePackages;
  cargoTestFlags = workspacePackages;

  env =
    lib.optionalAttrs withCraftFonts {
      CRAFT_FONTS_DIR = "${craftFonts}";
      CRAFT_FONTS_REQUIRED = "1";
    }
    // {
      PDFCRAFT_BUILD_SHA = commit;
      PDFCRAFT_BUILD_DATE = buildDate;
    };

  preBuild = ''
    # Work around LLVM intrinsic signature mismatch for _mm512_dpbusd_epi32 in rten-gemm under rustc >= 1.98
    for f in $(find .. -name i8dot.rs 2>/dev/null); do
      if grep -q "_mm512_dpbusd_epi32" "$f"; then
        chmod +w "$f"
        substituteInPlace "$f" \
          --replace-fail 'use std::arch::x86_64::_mm512_dpbusd_epi32;' 'use std::arch::asm;' \
          --replace-fail '_mm512_dpbusd_epi32(acc.0, a.0, b.0).into()' '{ let mut res = acc.0; asm!("vpdpbusd {result}, {a}, {b}", result = inout(zmm_reg) res, a = in(zmm_reg) a.0, b = in(zmm_reg) b.0, options(nostack)); res.into() }'
      fi
    done
  '';

  postInstall = ''
    install -Dm644 packaging/linux/ai.storyteller.pdfcraft.desktop $out/share/applications/ai.storyteller.pdfcraft.desktop
    install -Dm644 packaging/linux/ai.storyteller.pdfcraft.mime.xml $out/share/mime/packages/ai.storyteller.pdfcraft.xml

    mkdir -p $out/share/metainfo
    sed -e "s/@VERSION@/${version}/g" -e "s/@DATE@/${buildDate}/g" \
      packaging/linux/ai.storyteller.pdfcraft.metainfo.xml.in > $out/share/metainfo/ai.storyteller.pdfcraft.metainfo.xml

    mkdir -p $out/share/icons
    cp -r assets/app-icon/hicolor $out/share/icons/

    mkdir -p $out/share/doc/pdfcraft
    for f in README.md LICENSE LICENSE-MIT LICENSE-APACHE COPYRIGHT NOTICE ATTRIBUTION.md; do
      if [ -f "$f" ]; then
        install -Dm644 "$f" "$out/share/doc/pdfcraft/$f"
      fi
    done
  ''
  + lib.optionalString withCraftFonts ''
    for lic in ${craftFonts}/fonts/*/OFL.txt; do
      if [ -f "$lic" ]; then
        fam=$(basename $(dirname "$lic"))
        install -Dm644 "$lic" "$out/share/doc/pdfcraft/OFL-$fam.txt"
      fi
    done
  ''
  + lib.optionalString withOcrModels ''
        mkdir -p $out/share/pdfcraft/models
        cp ${ocrDetectionModel} $out/share/pdfcraft/models/text-detection.rten
        cp ${ocrRecognitionModel} $out/share/pdfcraft/models/text-recognition.rten
        cp ${ocrLicence} $out/share/pdfcraft/models/text-detection.rten.LICENCE.txt
        cp ${ocrLicence} $out/share/pdfcraft/models/text-recognition.rten.LICENCE.txt
        cat > $out/share/pdfcraft/models/ATTRIBUTION.txt << 'EOF'
    PdfCraft's text recognition (Scan & OCR) uses these models, unmodified.

    text-detection.rten
      Ocrs text detection model
      by Robert Knight (ocrs-models; trained on HierText, CC-BY-SA-4.0)
      from https://github.com/robertknight/ocrs-models (the models ocrs downloads; model card: https://huggingface.co/robertknight/ocrs, cc-by-sa-4.0)
      licence: CC-BY-SA-4.0 (https://creativecommons.org/licenses/by-sa/4.0/legalcode.txt; full text in text-detection.rten.LICENCE.txt)

    text-recognition.rten
      Ocrs text recognition model
      by Robert Knight (ocrs-models; trained on HierText, CC-BY-SA-4.0)
      from https://github.com/robertknight/ocrs-models (the models ocrs downloads; model card: https://huggingface.co/robertknight/ocrs, cc-by-sa-4.0)
      licence: CC-BY-SA-4.0 (https://creativecommons.org/licenses/by-sa/4.0/legalcode.txt; full text in text-recognition.rten.LICENCE.txt)
    EOF
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
        wrapProgram $out/bin/pdfcraft \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
          ${lib.optionalString withOcrModels "--set-default PDFCRAFT_MODELS \"$out/share/pdfcraft/models\""} \
          ${
            lib.optionalString (xwayland != null) "--prefix PATH : \"${lib.makeBinPath [ xwayland ]}\""
          } \
          ${lib.optionalString defaultToXWayland "--unset WAYLAND_DISPLAY --unset WAYLAND_SOCKET"}

        wrapProgram $out/bin/pdfcraft-cli \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
          ${lib.optionalString withOcrModels "--set-default PDFCRAFT_MODELS \"$out/share/pdfcraft/models\""}

        makeWrapper $out/bin/.pdfcraft-wrapped $out/bin/pdfcraft-xwayland \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
          ${lib.optionalString withOcrModels "--set-default PDFCRAFT_MODELS \"$out/share/pdfcraft/models\""} \
          ${
            lib.optionalString (xwayland != null) "--prefix PATH : \"${lib.makeBinPath [ xwayland ]}\""
          } \
          --unset WAYLAND_DISPLAY \
          --unset WAYLAND_SOCKET

        makeWrapper $out/bin/.pdfcraft-wrapped $out/bin/pdfcraft-wayland \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
          ${lib.optionalString withOcrModels "--set-default PDFCRAFT_MODELS \"$out/share/pdfcraft/models\""} \
          ${lib.optionalString (xwayland != null) "--prefix PATH : \"${lib.makeBinPath [ xwayland ]}\""}

        cat >> $out/share/applications/ai.storyteller.pdfcraft.desktop <<EOF

    Actions=XWayland;Wayland;

    [Desktop Action XWayland]
    Name=Open under XWayland (Drag and Drop support)
    Exec=pdfcraft-xwayland %U

    [Desktop Action Wayland]
    Name=Open under native Wayland
    Exec=pdfcraft-wayland %U
    EOF
  '';

  meta = with lib; {
    description = "Clean-room PDF workbench to read, edit, annotate, sign, and optimize PDFs";
    homepage = "https://github.com/storytold/pdfcraft";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ johnrizzo1 ];
    mainProgram = "pdfcraft";
    platforms = platforms.unix;
  };
}
