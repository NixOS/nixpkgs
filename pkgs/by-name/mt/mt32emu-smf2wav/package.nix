{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  nix,
  writeShellApplication,
  _experimental-update-script-combinators,
  cmake,
  glib,
  libmt32emu,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mt32emu-smf2wav";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "munt";
    repo = "munt";
    rev = "mt32emu_smf2wav_${lib.replaceString "." "_" finalAttrs.version}";
    sha256 = "sha256-QuOQvKNCKl/UypTub9FCoYu3HJrMi6LksKPGaQUWfO8=";
  };

  postPatch =
    # Make sure system-installed libmt32emu is used
    # Don't depend on in-tree mt32emu to be used
    ''
      substituteInPlace CMakeLists.txt \
        --replace-fail 'add_subdirectory(mt32emu)' "" \
        --replace-fail 'add_dependencies(mt32emu-smf2wav mt32emu)' ""
    '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libmt32emu
    glib
  ];

  cmakeFlags = [
    (lib.cmakeBool "munt_WITH_MT32EMU_QT" false)
    (lib.cmakeBool "munt_WITH_MT32EMU_SMF2WAV" true)
  ];

  passthru = {
    # Otherwise x.y.z in version != x_y_z in tag, and bump to same version is attempted
    unfixVersionScript = writeShellApplication {
      name = "unfix-mt32emu-smf2wav-version";

      runtimeInputs = [
        nix
      ];

      text = ''
        export UPDATE_NIX_ATTR_PATH="''${UPDATE_NIX_ATTR_PATH:-mt32emu-smf2wav}"

        preUpdateScriptVersion="$(nix-instantiate . --eval --strict -A "$UPDATE_NIX_ATTR_PATH.version" | cut -d'"' -f2)"
        unfixedVersion="''${preUpdateScriptVersion//\./_}"

        pkgFile="$(nix-instantiate --eval -E "with import ./. {}; (builtins.unsafeGetAttrPos \"version\" $UPDATE_NIX_ATTR_PATH).file" | cut -d'"' -f2)"

        sed -i -e "s/version = \"$preUpdateScriptVersion\"/version = \"$unfixedVersion\"/g" "$pkgFile"
      '';
    };

    updateTagScript = gitUpdater {
      rev-prefix = "mt32emu_smf2wav_";
    };

    # gitUpdater lacks an option for modifying new tag
    fixVersionScript = writeShellApplication {
      name = "fix-mt32emu-smf2wav-version";

      runtimeInputs = [
        nix
      ];

      text = ''
        export UPDATE_NIX_ATTR_PATH="''${UPDATE_NIX_ATTR_PATH:-mt32emu-smf2wav}"

        postUpdateScriptVersion="$(nix-instantiate . --eval --strict -A "$UPDATE_NIX_ATTR_PATH.version" | cut -d'"' -f2)"
        fixedVersion="''${postUpdateScriptVersion//_/.}"

        pkgFile="$(nix-instantiate --eval -E "with import ./. {}; (builtins.unsafeGetAttrPos \"version\" $UPDATE_NIX_ATTR_PATH).file" | cut -d'"' -f2)"

        sed -i -e "s/version = \"$postUpdateScriptVersion\"/version = \"$fixedVersion\"/g" "$pkgFile"
      '';
    };

    updateScript = _experimental-update-script-combinators.sequence [
      (lib.getExe finalAttrs.passthru.unfixVersionScript)
      (finalAttrs.passthru.updateTagScript.command)
      (lib.getExe finalAttrs.passthru.fixVersionScript)
    ];
  };

  meta = {
    homepage = "https://munt.sourceforge.net/";
    description = "Produces a WAVE file from a Standard MIDI file (SMF)";
    mainProgram = "mt32emu-smf2wav";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.all;
  };
})
