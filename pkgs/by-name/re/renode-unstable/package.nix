{
  fetchFromGitHub,
  nix-update-script,
  renode,
<<<<<<< HEAD
  lib,
}:
let
  normalizedVersion =
    v:
    let
      parts = lib.splitString "-" v;
      result = builtins.head parts;
    in
    result;
in
renode.overrideAttrs (old: rec {
  pname = "renode-unstable";
  version = "1.16.0-unstable-2025-12-11";
=======
}:
renode.overrideAttrs (old: rec {
  pname = "renode-unstable";
  version = "1.16.0-unstable-2025-08-08";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "renode";
    repo = "renode";
<<<<<<< HEAD
    rev = "e61a4063ec362b099704e6d8f9734cdf792aeeb0";
    hash = "sha256-ucQguZZSNKa0nEOTCdcLyDlaBnRgi/7Yb6VunNG/iSg=";
=======
    rev = "194d90650a9337a05cd81e8855474773d23d4396";
    hash = "sha256-oRtbjup5RKbVzKMTa0yiY1gGhDqUrQ4N3SgwQ7lm8Ho=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    fetchSubmodules = true;
  };

  prePatch = ''
<<<<<<< HEAD
    sed -i 's/AssemblyVersion("%VERSION%.*")/AssemblyVersion("${normalizedVersion version}.0")/g' src/Renode/Properties/AssemblyInfo.template
    sed -i 's/AssemblyInformationalVersion("%INFORMATIONAL_VERSION%")/AssemblyInformationalVersion("${src.rev}")/g' src/Renode/Properties/AssemblyInfo.template
    mv src/Renode/Properties/AssemblyInfo.template src/Renode/Properties/AssemblyInfo.cs
=======
    substituteInPlace tools/building/createAssemblyInfo.sh \
      --replace CURRENT_INFORMATIONAL_VERSION="`git rev-parse --short=8 HEAD`" \
      CURRENT_INFORMATIONAL_VERSION="${builtins.substring 0 8 src.rev}"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  passthru = old.passthru // {
    updateScript = nix-update-script {
      extraArgs = [
        "--version=branch"
      ];
    };
  };
})
