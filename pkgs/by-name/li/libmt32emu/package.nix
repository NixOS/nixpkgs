{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  nix,
  testers,
  writeShellApplication,
  _experimental-update-script-combinators,
  cmake,
  doctest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmt32emu";
  version = "2.8.6";

  src = fetchFromGitHub {
    owner = "munt";
    repo = "munt";
    tag = "libmt32emu_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-vCOec3DwYeQqSDpvGGON5IxI1lueuJM9d8XAufgCL9w=";
  };

  outputs = [
    "out"
    "dev"
  ];

  postPatch = ''
    substituteInPlace mt32emu/src/mt32emu.pc.in \
      --replace-fail \
        'libdir=''${exec_prefix}/@CMAKE_INSTALL_LIBDIR@' \
        'libdir=@CMAKE_INSTALL_FULL_LIBDIR@' \
      --replace-fail \
        'includedir=''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@' \
        'includedir=@CMAKE_INSTALL_FULL_INCLUDEDIR@'
  '';

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  checkInputs = [
    doctest
  ];

  cmakeFlags = [
    (lib.strings.cmakeBool "munt_WITH_MT32EMU_SMF2WAV" false)
    (lib.strings.cmakeBool "munt_WITH_MT32EMU_QT" false)
    (lib.strings.cmakeFeature "libmt32emu_MATH_TYPE_FOR_FLOAT_RENDERER" "Standard") # best accuracy
    (lib.strings.cmakeBool "libmt32emu_TESTS_DETAILED" true)
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru = {
    tests = {
      cmake = testers.hasCmakeConfigModules {
        package = finalAttrs.finalPackage;
        versionCheck = true;
      };
      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage;
        versionCheck = true;
      };
    };

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
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.unix; # Not tested on ReactOS yet :)
    cmakeConfigModules = [ "MT32Emu" ];
    pkgConfigModules = [ "mt32emu" ];
  };
})
