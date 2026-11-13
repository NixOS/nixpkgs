{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "last-resort";
  version = "18.000";

  __structuredAttrs = true;
  strictDeps = true;
  enableParallelBuilding = false; # nothing to parallelize
  doCheck = false; # no tests to run

  src = fetchFromGitHub {
    owner = "unicode-org";
    repo = "last-resort-font";
    tag = finalAttrs.version;
    hash = "sha256-kbuXVQnfuenjsMnxdOdgo20B/Dw7vV8+jI76FqTxgtc=";
  };

  patches = [
    ./bash.patch
  ];

  postPatch = ''
    patchShebangs --build ./build.sh
  '';

  nativeBuildInputs = [
    (python3.withPackages (
      pypkgs: with pypkgs; [
        afdko
      ]
    ))
    installFonts
  ];

  buildPhase = ''
    runHook preBuild
    ./build.sh
    runHook postBuild
  '';

  meta = {
    description = "Fallback font of last resort";
    homepage = "https://github.com/unicode-org/last-resort-font";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [
      sandarukasa
    ];
  };
})
