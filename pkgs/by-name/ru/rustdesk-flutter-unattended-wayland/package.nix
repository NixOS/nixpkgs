{
  lib,
  rustdesk-flutter,
  libdrmtap,
  libglvnd,
  systemd,
  procps,
  coreutils,
  findutils,
  util-linux,
  getent,
  gawk,
  gnugrep,
  gnused,
  which,
  xdg-utils,
  testers,
}:

rustdesk-flutter.overrideAttrs (
  finalAttrs: previousAttrs: {
    cargoBuildFeatures = previousAttrs.cargoBuildFeatures ++ [
      "drm"
      "drm-wake"
    ];

    __structuredAttrs = true;

    # passAsFile is ignored with structured attributes.
    pubspecLockFilePath = builtins.toFile "rustdesk-pubspec.lock" previousAttrs.pubspecLockFile;

    patches = previousAttrs.patches ++ [ ./reenter-wrapper.patch ];

    postPatch = ''
      # Root must load the capture library from a trusted absolute path.
      substituteInPlace libs/scrap/src/common/drmtap_dl.rs \
        --replace-fail '/usr/lib/rustdesk/libdrmtap.so.0' '${lib.getLib libdrmtap}/lib/libdrmtap.so.0'
      substituteInPlace src/platform/linux.rs \
        --replace-fail '@rustdesk-wrapper@' '${placeholder "out"}/bin/rustdesk'
      # Match the extended_text version in the inherited lockfile.
      substituteInPlace flutter/pubspec.yaml \
        --replace-fail 'extended_text: 14.0.0' 'extended_text: 15.0.2'
    ''
    + previousAttrs.postPatch;

    # Prefer the host's setuid wrappers on NixOS; elsewhere sudo/su are found
    # through the inherited PATH. Store sudo/su binaries are not setuid.
    extraWrapProgramArgs = ''
      ${lib.trim previousAttrs.extraWrapProgramArgs} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libglvnd ]} \
      --prefix PATH : /run/wrappers/bin:${
        lib.makeBinPath [
          systemd
          procps
          coreutils
          findutils
          util-linux
          getent
          gawk
          gnugrep
          gnused
          which
          xdg-utils
        ]
      }
    '';

    doInstallCheck = true;
    installCheckPhase = ''
      runHook preInstallCheck

      rustLibrary="$out/app/$pname/lib/librustdesk.so"
      test -x "$out/bin/rustdesk"
      grep -aFq '${lib.getLib libdrmtap}/lib/libdrmtap.so.0' "$rustLibrary"
      grep -aFq 'enable-drm-display-wake' "$rustLibrary"
      grep -aFq "$out/bin/rustdesk" "$rustLibrary"
      if grep -aFq '/usr/lib/rustdesk/libdrmtap.so.0' "$rustLibrary"; then
        echo 'Unpatched DRM loader path in RustDesk' >&2
        exit 1
      fi

      runHook postInstallCheck
    '';

    passthru = (previousAttrs.passthru or { }) // {
      tests = (previousAttrs.passthru.tests or { }) // {
        version = testers.testVersion {
          package = finalAttrs.finalPackage;
        };
      };
    };

    meta = previousAttrs.meta // {
      description = "Remote desktop client with unattended Wayland support";
      maintainers = with lib.maintainers; [ telometto ];
    };
  }
)
