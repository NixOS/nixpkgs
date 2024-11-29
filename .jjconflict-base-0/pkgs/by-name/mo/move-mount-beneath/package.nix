{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
}:

stdenv.mkDerivation {
  pname = "move-mount-beneath";
  version = "unstable-2023-11-26";

  src = fetchFromGitHub {
    owner = "brauner";
    repo = "move-mount-beneath";
    rev = "d3d16c0d7766eb1892fcc24a75f8d35df4b0fe45";
    hash = "sha256-hUboFthw9ABwK6MRSNg7+iu9YbiJALNdsw9Ub3v43n4=";
  };

  installPhase = ''
    runHook preInstall
    install -D move-mount $out/bin/move-mount
    runHook postInstall
  '';

  patches = [
    # Fix uninitialized variable in flags_attr, https://github.com/brauner/move-mount-beneath/pull/2
    (fetchpatch {
      name = "aarch64";
      url = "https://github.com/brauner/move-mount-beneath/commit/0bd0b863f7b98608514d90d4f2a80a21ce2e6cd3.patch";
      hash = "sha256-D3TttAT0aFqpYC8LuVnrkLwDcfVFOSeYzUDx6VqPu1Q=";
    })
  ];

  meta = {
    description = "Toy binary to illustrate adding a mount beneath an existing mount";
    mainProgram = "move-mount";
    homepage = "https://github.com/brauner/move-mount-beneath";
    license = lib.licenses.mit0;
    maintainers = with lib.maintainers; [ nikstur ];
  };
}
