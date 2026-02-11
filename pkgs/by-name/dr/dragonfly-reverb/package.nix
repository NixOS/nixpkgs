{
  lib,
  stdenv,
  fetchFromGitHub,
  libjack2,
  libGL,
  pkg-config,
  libx11,

  buildStandalone ? true,
  buildVST3 ? true,
  buildLV2 ? true,
  buildCLAP ? true,
  buildVST2 ? false, # can't distribute
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dragonfly-reverb";
  version = "3.2.10";

  src = fetchFromGitHub {
    owner = "michaelwillis";
    repo = "dragonfly-reverb";
    tag = finalAttrs.version;
    hash = "sha256-YXJ4U5J8Za+DlXvp6QduvCHIVC2eRJ3+I/KPihCaIoY=";
    fetchSubmodules = true;
  };

  postPatch =
    let
      targets = lib.concatStringsSep " " [
        (lib.optionalString buildStandalone "jack")
        (lib.optionalString buildVST3 "vst3")
        (lib.optionalString buildLV2 "lv2_sep")
        (lib.optionalString buildCLAP "clap")
        (lib.optionalString buildVST2 "vst2")
      ];
    in
    ''
      patchShebangs dpf/utils/generate-ttl.sh

      substituteInPlace plugins/*/Makefile \
        --replace-fail "TARGETS = jack lv2_sep vst2 vst3 clap" "TARGETS = ${targets}"
    '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libjack2
    libx11
    libGL
  ];

  installPhase = ''
    runHook preInstall

    ${lib.optionalString buildVST3 ''
      mkdir -p $out/lib/vst3
    ''}

    ${lib.optionalString buildLV2 ''
      mkdir -p $out/lib/lv2
    ''}

    ${lib.optionalString buildCLAP ''
      mkdir -p $out/lib/clap
    ''}

    pushd bin
      for bin in DragonflyEarlyReflections DragonflyPlateReverb DragonflyHallReverb DragonflyRoomReverb; do
        ${lib.optionalString buildStandalone ''
          install -Dm755 $bin -t $out/bin
        ''}

        ${lib.optionalString buildVST3 ''
          cp -r $bin.vst3 $out/lib/vst3
        ''}

        ${lib.optionalString buildLV2 ''
          cp -r $bin.lv2 $out/lib/lv2
        ''}

        ${lib.optionalString buildCLAP ''
          cp -r $bin.clap $out/lib/clap
        ''}

        ${lib.optionalString buildVST2 ''
          install -Dm755 $bin-vst.so -t $out/lib/vst
        ''}
      done
    popd

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/michaelwillis/dragonfly-reverb";
    description = "Hall-style reverb based on freeverb3 algorithms";
    maintainers = with lib.maintainers; [
      magnetophon
      mrtnvgr
    ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    badPlatforms = [ lib.systems.inspect.patterns.isAarch ];
  };
})
