{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  nix,
  writeShellApplication,
  _experimental-update-script-combinators,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmt32emu";
  version = "2.8.3";

  src = fetchFromGitHub {
    owner = "munt";
    repo = "munt";
    tag = "libmt32emu_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-QuOQvKNCKl/UypTub9FCoYu3HJrMi6LksKPGaQUWfO8=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-Dmunt_WITH_MT32EMU_SMF2WAV=OFF"
    "-Dmunt_WITH_MT32EMU_QT=OFF"
  ];

  postFixup = ''
    substituteInPlace "$dev"/lib/pkgconfig/mt32emu.pc \
      --replace '=''${exec_prefix}//' '=/' \
      --replace "$dev/$dev/" "$dev/"
  '';

  passthru = {
    # Otherwise x.y.z in version != x_y_z in tag, and bump to same version is attempted
    unfixVersionScript = writeShellApplication {
      name = "unfix-libmt32emu-version";

      runtimeInputs = [
        nix
      ];

      text = ''
        export UPDATE_NIX_ATTR_PATH="''${UPDATE_NIX_ATTR_PATH:-libmt32emu}"

        preUpdateScriptVersion="$(nix-instantiate . --eval --strict -A "$UPDATE_NIX_ATTR_PATH.version" | cut -d'"' -f2)"
        unfixedVersion="''${preUpdateScriptVersion//\./_}"

        pkgFile="$(nix-instantiate --eval -E "with import ./. {}; (builtins.unsafeGetAttrPos \"version\" $UPDATE_NIX_ATTR_PATH).file" | cut -d'"' -f2)"

        sed -i -e "s/version = \"$preUpdateScriptVersion\"/version = \"$unfixedVersion\"/g" "$pkgFile"
      '';
    };

    updateTagScript = gitUpdater {
      rev-prefix = "libmt32emu_";
    };

    # gitUpdater lacks an option for modifying new tag
    fixVersionScript = writeShellApplication {
      name = "fix-libmt32emu-version";

      runtimeInputs = [
        nix
      ];

      text = ''
        export UPDATE_NIX_ATTR_PATH="''${UPDATE_NIX_ATTR_PATH:-libmt32emu}"

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
    description = "Library to emulate Roland MT-32, CM-32L, CM-64 and LAPC-I devices";
    license = with lib.licenses; [ lgpl21Plus ];
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.unix; # Not tested on ReactOS yet :)
  };
})
