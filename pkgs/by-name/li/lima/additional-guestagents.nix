{
  lib,
  stdenv,
  buildGoModule,
  callPackage,
  apple-sdk_15,
  findutils,
}:

buildGoModule (finalAttrs: {
  pname = "lima-additional-guestagents";

  # Because agents must use the same version as lima, lima's updateScript should also update the shared src.
  # nixpkgs-update: no auto update
  inherit (callPackage ./source.nix { }) version src vendorHash;

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_15
  ];

  buildPhase =
    let
      makeFlags = [
        "VERSION=v${finalAttrs.version}"
        "CC=${stdenv.cc.targetPrefix}cc"
      ];
    in
    ''
      runHook preBuild

      make ${lib.escapeShellArgs makeFlags} additional-guestagents

      runHook postBuild
    '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r _output/* $out

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    findutils
  ];
  doInstallCheck = true;

  # Guest agents for the host's architecture are only in the "lima" package. So, we can't test this by running the binary.
  installCheckPhase = ''
    runHook preInstallCheck

    [[ "$(find "$out/share" -type f -name 'lima-guestagent.Linux-*.gz' | wc -l)" -ge 5 ]]

    runHook postInstallCheck
  '';

  meta = {
    homepage = "https://github.com/lima-vm/lima";
    description = "Lima Guest Agents for emulating non-native architectures";
    longDescription = ''
      This package should only be used when your guest's architecture differs from the host's.

      To enable its functionality in `limactl`, set `withAdditionalGuestAgents = true` in the `lima` package:
      ```nix
      pkgs.lima.override {
        withAdditionalGuestAgents = true;
      }
      ```

      Typically, you won't need to directly add this package to your *.nix files.
    '';
    changelog = "https://github.com/lima-vm/lima/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kachick
    ];
  };
})
