{
  lib,
  fetchFromGitHub,
  nix-update-script,
  openttd,
  zstd,
}:

openttd.overrideAttrs (
  finalAttrs: oldAttrs: {
    pname = "openttd-jgrpp";
    version = "0.73.4";

    src = fetchFromGitHub {
      owner = "JGRennison";
      repo = "OpenTTD-patches";
      tag = "jgrpp-${finalAttrs.version}";
      hash = "sha256-9vHFDGT0d96jfTkIjYqE79Y/SgubuFkGSrystfWWhTE=";
    };

    buildInputs = oldAttrs.buildInputs ++ [ zstd ];

    buildFlags = [
      "all"
      "openttd_test"
    ];

    passthru = oldAttrs.passthru // {
      updateScript = nix-update-script {
        extraArgs = [
          "--version-regex"
          "jgrpp-(.*)"
        ];
      };
    };

    meta = oldAttrs.meta // {
      description = "OpenTTD with JGR's patch pack";
      homepage = "https://github.com/JGRennison/OpenTTD-patches";
      changelog = "https://github.com/JGRennison/OpenTTD-patches/blob/jgrpp-${finalAttrs.version}/jgrpp-changelog.md";
      maintainers = with lib.maintainers; [ artifycz ];
      downloadPage = "https://github.com/JGRennison/OpenTTD-patches/releases";
    };
  }
)
