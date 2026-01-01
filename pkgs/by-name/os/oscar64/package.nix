{
  lib,
  stdenv,
  nix-update-script,
  fetchFromGitHub,
<<<<<<< HEAD
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "oscar64";
  version = "1.32.266";
=======
  fetchpatch2,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "oscar64";
  version = "1.32.265";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "drmortalwombat";
    repo = "oscar64";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-udbVRdGIGv3jgeh1cKp7MhSDxNs56FlqEbpzgfWcieE=";
  };

=======
    hash = "sha256-nPwebydRFHoIWp2sbfPaudKj/sPZRKamYdIuSVZ9dcc=";
  };

  patches = [
    (fetchpatch2 {
      name = "fix-make-install.patch";
      url = "https://github.com/drmortalwombat/oscar64/commit/af9e06a467be07422bc87058bebdef79e0a94ea1.patch?full_index=1";
      hash = "sha256-YsbdYi+dwLQSGOT8krJsFqJxS0EpIiQqavQpH0nl7S0=";
    })
  ];

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  postPatch = ''
    substituteInPlace ./oscar64.1 \
      --replace-fail "/usr/local/bin/oscar64" "$out/bin/oscar64" \
      --replace-fail "/usr/local/share/oscar64/" "$out/include/oscar64"
  '';

  enableParallelBuilding = true;

  makeFlags = [
    "-C ./make"
    "prefix=$(out)"
  ];

  buildTarget = "compiler";

  doCheck = true;
  checkTarget = "check";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Optimizing small memory C compiler, assembler, and runtime for C64";
    homepage = "https://github.com/drmortalwombat/oscar64";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.nekowinston ];
    mainProgram = "oscar64";
    platforms = lib.platforms.unix;
  };
})
