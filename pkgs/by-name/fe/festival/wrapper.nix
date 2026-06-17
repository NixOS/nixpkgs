{
  lib,
  symlinkJoin,
  makeWrapper,
  glibc,
  sox,
  festival,
  withSpeechdSupport ? false,
}:

voicesFn:
{
  defaultVoice ? null,
  extraSiteInit ? "",
}:
let
  selectedVoices = voicesFn (lib.filterAttrs (_: lib.isDerivation) festival.passthru.packages);

  extraBins = lib.unique (lib.concatMap (v: v.passthru.extraBinDeps or [ ]) selectedVoices);
  extraLibs = lib.unique (lib.concatMap (v: v.passthru.extraLibDeps or [ ]) selectedVoices);
  voiceSiteInit = lib.concatMapStrings (v: v.passthru.siteInit or "") selectedVoices;

  mbrolaPackage = lib.findFirst (p: lib.getName p == "mbrola") null extraBins;

  defaultVoiceSiteInit = lib.optionalString (
    defaultVoice != null
  ) "(set! voice_default 'voice_${defaultVoice})\n";
  combinedSiteInit = voiceSiteInit + defaultVoiceSiteInit + extraSiteInit;
in
symlinkJoin {
  name = "${festival.pname}-with-voices";
  paths = [ festival ] ++ selectedVoices ++ extraLibs;
  meta = festival.meta;
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    for bin in $out/bin/*; do
      if [ -e "$bin" ]; then
        if [[ "$(basename "$bin")" != *"-wrapped" ]]; then
          wrapProgram "$bin" \
            --set-default FESTLIBDIR "$out/lib" \
            --prefix PATH : "${
              lib.makeBinPath (
                lib.optionals withSpeechdSupport [
                  glibc
                  sox
                ]
                ++ extraBins
              )
            }"
        fi
      fi
    done

    ${lib.optionalString (combinedSiteInit != "") ''
      cp --remove-destination $(realpath $out/lib/siteinit.scm) $out/lib/siteinit.scm
      chmod u+w $out/lib/siteinit.scm
      substituteInPlace $out/lib/siteinit.scm \
        --replace-fail \
          "(provide 'siteinit)" \
          ""
      cat >> $out/lib/siteinit.scm << 'EOF'
      ${combinedSiteInit}
      (provide 'siteinit)
      EOF
    ''}

    ${lib.optionalString (mbrolaPackage != null) ''
      cp --remove-destination $(realpath $out/lib/mbrola.scm) $out/lib/mbrola.scm
      substituteInPlace $out/lib/mbrola.scm \
        --replace-fail \
          '"/cstr/external/mbrola/mbrola"' \
          '"${mbrolaPackage}/bin/mbrola"'
    ''}
  '';
}
