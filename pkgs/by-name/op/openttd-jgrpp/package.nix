{
  lib,
  fetchFromGitHub,
  nix-update-script,
  openttd,
  zstd,
}:

openttd.overrideAttrs (oldAttrs: rec {
  pname = "openttd-jgrpp";
  version = "0.73.5";

  src = fetchFromGitHub {
    owner = "JGRennison";
    repo = "OpenTTD-patches";
    rev = "jgrpp-${version}";
    hash = "sha256-V5o2hkk2QNXy6GcmV6nuVuBQQfHdRLZhrW35VEasuF8=";
  };
  patches = [ ];

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

  meta = {
    homepage = "https://github.com/JGRennison/OpenTTD-patches";
    changelog = "https://github.com/JGRennison/OpenTTD-patches/blob/jgrpp-${version}/jgrpp-changelog.md";
    mainProgram = "openttd";
    maintainers = with lib.maintainers; [ artifycz ];
  };

})
