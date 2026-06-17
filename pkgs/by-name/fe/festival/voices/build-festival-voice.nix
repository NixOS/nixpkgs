{
  lib,
  stdenv,
  runCommand,
  festival,
}:

attrsOrFn:

let
  attrs = if lib.isFunction attrsOrFn then lib.fix attrsOrFn else attrsOrFn;
  voiceName = attrs.passthru.voiceName;
in

stdenv.mkDerivation (
  finalAttrs:
  let
    defaultPassthru = {
      inherit voiceName;
      tests.synthesizes =
        runCommand "${finalAttrs.pname}-test"
          {
            nativeBuildInputs = [
              (festival.withSiteInitConfig (_: [ finalAttrs.finalPackage ]) { defaultVoice = voiceName; })
            ];
          }
          ''
            # Test if the voice can produce sound
            tmpfile=$(mktemp /tmp/XXXXXX.wav)
            output=$(echo "(utt.save.wave \
              (utt.synth (Utterance Text \"hello world\")) \
              \"$tmpfile\")" | festival 2>&1) && festivalExit=0 || festivalExit=$?
            if echo "$output" | grep -qE "SIOD ERROR|Cannot open|No such file|sh: "; then
              echo "Error detected:"
              echo "$output"
              exit 1
            fi
            size=$(stat -c%s "$tmpfile")
            test $size -gt 44 || (echo "No audio generated (only $size bytes)" && exit 1)

            # Test if the voice shows in the voice.list
            if ! echo "(print (voice.list))" | festival 2>&1 | grep -q "${voiceName}"; then
              echo "Voice ${voiceName} not found in voice-locations"
              exit 1
            fi

            mkdir $out
          '';
    };
  in
  {
    dontBuild = true;
    dontConfigure = true;
    dontFixup = true;
    __structuredAttrs = true;
    strictDeps = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"
      cp -r lib "$out/lib"

      runHook postInstall
    '';

    passthru = defaultPassthru // (attrs.passthru or { });

    meta.platforms = lib.platforms.all;

  }
  // (removeAttrs attrs [ "passthru" ])
)
