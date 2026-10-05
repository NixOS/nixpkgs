{
  lib,
  stdenv,
  fetchurl,

  fasm,
  makeBinaryWrapper,
  unzip,
}:

stdenv.mkDerivation {
  pname = "fasmarm";
  version = "1.44";

  # FASMARM is a source overlay, not a loadable add-on, so it must be built as
  # a separate FASM-based executable.
  src = fasm.src;

  # Unfortunately the download URL is unversioned. New releases
  # are rare so this should be fine most of the time. When there's
  # a new release the hash needs to be regenerated
  fasmarmOverlay = fetchurl {
    url = "https://arm.flatassembler.net/FASMARM_small.ZIP";
    hash = "sha256-5ZzGl/C+hHRVYVyYBRns7hl3gy+cy89Eiq+9/nokk4Q=";
  };

  prePatch = ''
    unzip "$fasmarmOverlay"
  '';

  strictDeps = true;
  __structuredAttrs = true;
  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [
    fasm
    makeBinaryWrapper
    unzip
  ];

  buildPhase = ''
    runHook preBuild

    fasm -m 65536 source/linux${lib.optionalString stdenv.hostPlatform.isx86_64 "/x64"}/fasmarm.asm fasmarm

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 fasmarm $out/bin/fasmarm

    # Both licenses require reproducing their notices with binary distributions.
    install -Dm644 license.txt $doc/share/doc/fasmarm/LICENSE.fasm
    sed -n '1,34p' source/armv8.inc > $doc/share/doc/fasmarm/LICENSE.fasmarm
    install -Dm644 ReadMe.txt $doc/share/doc/fasmarm/README

    mkdir -p $out/share/fasmarm
    cp -r include $out/share/fasmarm

    wrapProgram $out/bin/fasmarm \
      --set-default INCLUDE "$out/share/fasmarm/include"

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    cat > test.asm <<'EOF'
    include 'macro/armstruc.inc'
    processor cpu64_v8
    code64
    mov x0,42
    EOF
    printf '\x40\x05\x80\xd2' > expected.bin

    $out/bin/fasmarm test.asm test.bin
    cmp expected.bin test.bin

    runHook postInstallCheck
  '';

  meta = {
    description = "FASM-based assembler for 32-bit and 64-bit ARM processors";
    homepage = "https://arm.flatassembler.net/";
    license = lib.licenses.bsd2;
    mainProgram = "fasmarm";
    maintainers = with lib.maintainers; [
      evanwporter
      iamanaws
    ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
}
