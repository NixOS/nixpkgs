{
  fetchFromGitHub,
  nix-update-script,
  renode,
}:
renode.overrideAttrs (old: rec {
  pname = "renode-unstable";
  version = "1.16.0-unstable-2025-08-08";

  src = fetchFromGitHub {
    owner = "renode";
    repo = "renode";
    rev = "194d90650a9337a05cd81e8855474773d23d4396";
    hash = "sha256-oRtbjup5RKbVzKMTa0yiY1gGhDqUrQ4N3SgwQ7lm8Ho=";
    fetchSubmodules = true;
  };

  prePatch = ''
    substituteInPlace tools/building/createAssemblyInfo.sh \
      --replace CURRENT_INFORMATIONAL_VERSION="`git rev-parse --short=8 HEAD`" \
      CURRENT_INFORMATIONAL_VERSION="${builtins.substring 0 8 src.rev}"
  '';

  passthru = old.passthru // {
    updateScript = nix-update-script {
      extraArgs = [
        "--version=branch"
      ];
    };
  };
})
