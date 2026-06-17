{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  symlinkJoin,
  callPackage,
  makeWrapper,

  # Toogles
  withSpeechdSupport ? true,

  # Dependencies
  speech-tools,
  ncurses,
  alsa-lib,
  glibc,
  sox,

  # Tests
  testers,
}:
# https://gitlab.archlinux.org/archlinux/packaging/packages/festival/-/blob/main/PKGBUILD?ref_type=heads
stdenv.mkDerivation (finalAttrs: {
  pname = "festival";
  version = "2.5.0";

  __structuredAttrs = true;
  strictDeps = true;

  srcs = [
    (fetchurl {
      url = "http://festvox.org/packed/${finalAttrs.pname}/${lib.versions.majorMinor finalAttrs.version}/${finalAttrs.pname}-${finalAttrs.version}-release.tar.gz";
      hash = "sha256-TJAHQmsSUpBZnZMd9BDi3vUeaKiu69ibSmHHyWwJpLQ=";
    })
    (fetchurl {
      url = "http://festvox.org/packed/${finalAttrs.pname}/${lib.versions.majorMinor finalAttrs.version}/festlex_CMU.tar.gz";
      hash = "sha256-wZQwkZvKRdU2jNTIKvYVP7zJakh+vTC3i188CHGLfAc=";
    })
    (fetchurl {
      url = "http://festvox.org/packed/${finalAttrs.pname}/${lib.versions.majorMinor finalAttrs.version}/festlex_OALD.tar.gz";
      hash = "sha256-4zo0U5DUx2+LmHsGpTMrzdCxaM9nyV3cMnD5Fjy+Yfg=";
    })
    (fetchurl {
      url = "http://festvox.org/packed/${finalAttrs.pname}/${lib.versions.majorMinor finalAttrs.version}/festlex_POSLEX.tar.gz";
      hash = "sha256-58bjZC29Ww1klCvAFamG/dYkSnnlHsLoMJ5j1WnknqM=";
    })
  ];

  freebsoftUtilsSrc = fetchFromGitHub {
    owner = "brailcom";
    repo = "festival-freebsoft-utils";
    # current master, 2026-06-21
    # it is a commit from February 11, 2013
    rev = "a7ef791e640fc9ff63ccbc0ee18ff71b94ac5255";
    hash = "sha256-C+JJfDuGEWN9VvlVUMkSknaJ8PJatsynPFZWpokZWCA=";
  };

  sourceRoot = "${finalAttrs.pname}";

  buildInputs = [
    speech-tools
    ncurses
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "CXX=${stdenv.cc.targetPrefix}c++"
  ];

  configureFlags = [
    "--prefix=${placeholder "out"}"
    "--libdir=${placeholder "out"}/lib"
  ];

  preConfigure = ''
    # Important: patch the compiled-in default path
     substituteInPlace config/project.mak \
       --replace-fail 'FTLIBDIR = $(FESTIVAL_HOME)/lib' \
                      'FTLIBDIR = ${placeholder "out"}/lib'

    sed -e s@/usr/bin/@@g -i $( grep -rl '/usr/bin/' . )
    sed -re 's@/bin/(rm|printf|uname)@\1@g' -i $( grep -rl '/bin/' . )

    substituteInPlace configure \
      --replace-fail 'main(){return(0);}' 'int main(){return(0);}'

  '';

  preBuild = ''
    substituteInPlace config/config \
      --replace-fail 'EST=$(TOP)/../speech_tools' 'EST=${
        symlinkJoin {
          name = "speech_tools-merged";
          paths = [
            speech-tools
            speech-tools.dev
          ];
        }
      }'
  '';

  postBuild = ''
    # Compile the docs
    (cd doc && make)
  '';

  # VCLocalRules is not a binary
  # default_voices cannot be used in a sandbox
  # text2wave is broken
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/man/man1
    mv doc/festival.1 doc/festival_client.1 "$out/share/man/man1/"

    mkdir -p "$out"/{bin,doc,lib}
    for d in bin doc lib; do
      for i in ./$d/*; do
        test "$(basename "$i")" = "Makefile" ||
        test "$i" = "./bin/VCLocalRules" ||
        test "$i" = "./bin/default_voices" ||
        test "$i" = "./bin/text2wave" ||
          cp -r "$(readlink -f $i)" "$out/$d"
      done
    done

    runHook postInstall
  '';

  postInstall = lib.optionalString withSpeechdSupport ''
    cp ${finalAttrs.freebsoftUtilsSrc}/*.scm $out/lib/
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "${finalAttrs.pname} --version";
      version = finalAttrs.version;
    };
  };

  passthru.packages = callPackage ./festival-voices-packages.nix { };

  passthru = {
    withVoices =
      voicesFn:
      finalAttrs.passthru.withSiteInitConfig voicesFn {
        defaultVoice = null;
        extraSiteInit = "";
      };

    withSiteInitConfig =
      voicesFn:
      {
        defaultVoice ? null,
        extraSiteInit ? "",
      }:
      let
        selectedVoices = voicesFn finalAttrs.passthru.packages;

        extraBins = lib.unique (lib.concatMap (v: v.passthru.extraBinDeps or [ ]) selectedVoices);
        extraLibs = lib.unique (lib.concatMap (v: v.passthru.extraLibDeps or [ ]) selectedVoices);
        voiceSiteInit = lib.concatMapStrings (v: v.passthru.siteInit or "") selectedVoices;

        defaultVoiceSiteInit = lib.optionalString (
          defaultVoice != null
        ) "(set! voice_default 'voice_${defaultVoice})\n";
        combinedSiteInit = voiceSiteInit + defaultVoiceSiteInit + extraSiteInit;
      in
      symlinkJoin {
        name = "${finalAttrs.pname}-with-voices";
        paths = [ finalAttrs.finalPackage ] ++ selectedVoices ++ extraLibs;
        meta = finalAttrs.meta;
        nativeBuildInputs = [ makeWrapper ];
        postBuild = ''
          # Wrap ALL executables in bin/ — this is the most robust approach
          for bin in $out/bin/*; do
            if [ -e "$bin" ]; then
              # Skip already-wrapped binaries (they end with -wrapped)
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
            # Remove the existing (provide 'siteinit) so we can place it last
            substituteInPlace $out/lib/siteinit.scm \
              --replace-fail \
                "(provide 'siteinit)" \
                ""
            cat >> $out/lib/siteinit.scm << 'EOF'
            ${combinedSiteInit}
            (provide 'siteinit)
            EOF
          ''}
        '';
      };
  };

  meta = {
    description = "Festival is a multi-lingual speech synthesis from the CMU";
    homepage = "http://festvox.org/festival/";
    license = with lib.licenses; [
      free # the license should be `festvox`
      # freebsoft-utils's license
      gpl2Only
    ];
    mainProgram = "festival";
    maintainers = with lib.maintainers; [ WiredMic ];
  };
})
