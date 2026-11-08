{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  lsp-plugins,
  bankstown-lv2,
  triforce-lv2,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "asahi-audio";
  version = "5.0";

  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "asahi-audio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pa7a4nu2QN32LxOoU2jy4mm11scfUELaGfuDo5Ggroo=";
  };

  makeFlags = [
    "DESTDIR=$(out)"
    "DATA_DIR=share"
  ];

  fixupPhase = ''
    runHook preFixup

    for config_file in $(find $out -type f -not -name '*.wav') ; do
        substituteInPlace "$config_file" --replace-warn "/usr" "$out"
    done

    runHook postFixup
  '';

  passthru = {
    updateScript = nix-update-script { };
    requiredLv2Packages = [
      lsp-plugins
      bankstown-lv2
      triforce-lv2
    ];
  };

  meta = {
    description = "Linux userspace audio configuration for Apple Silicon Macs";
    longDescription = ''
      This package contains DSP configuration files for Apple Silicon
      Macs supported by the Asahi Linux project. The goal is to make
      the Asahi Linux audio experience better than macOS, and in doing
      so demonstrate that desktop Linux audio can be made fit for
      purpose with a little bit of effort.

      Currently Supported Devices (speakers)
        - MacBook Air (13-inch, M1-M3)
        - MacBook Air (15-inch, M2-M3)
        - MacBook Pro (13-inch, M1/M2, 2020/2022)
        - MacBook Pro (14-inch, M3, M1-M3 Pro/Max)
        - MacBook Pro (16-inch, M1-M3 Pro/Max)
        - Mac mini (M1/M2/M2 Pro)
        - Mac Studio (M1-M3 Max/Ultra)

      Currently Supported Devices (microphones)
        - MacBook Air (13-inch, M1-M3)
        - MacBook Air (15-inch, M2-M3)
        - MacBook Pro (13-inch, M1/M2, 2020/2022)
        - MacBook Pro (14-inch, M3, M1-M3 Pro/Max)
        - MacBook Pro (16-inch, M1-M3 Pro/Max)

    '';
    homepage = "https://github.com/AsahiLinux/asahi-audio";
    changelog = "https://github.com/AsahiLinux/asahi-audio/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      flokli
      sempiternal-aurora
    ];
    platforms = [ "aarch64-linux" ];
  };
})
