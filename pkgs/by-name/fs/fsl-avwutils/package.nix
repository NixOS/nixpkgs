{
  lib,
  stdenv,
  fetchFromGitLab,
  fsl-base,
  fsl-utils,
  fsl-armawrap,
  fsl-cprob,
  fsl-newnifti,
  fsl-znzlib,
  fsl-miscmaths,
  fsl-newimage,
  nlohmann_json,
  blas,
  lapack,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fsl-avwutils";
  version = "2209.6";

  src = fetchFromGitLab {
    domain = "git.fmrib.ox.ac.uk";
    owner = "fsl";
    repo = "avwutils";
    rev = finalAttrs.version;
    hash = "sha256-qtvVuERT+oqiAx1BY/o7jv7hZ+a0ILw+kO52XgYpmlQ=";
  };

  buildInputs = [
    fsl-base
    fsl-utils
    fsl-armawrap
    fsl-cprob
    fsl-newnifti
    fsl-znzlib
    fsl-miscmaths
    fsl-newimage
    nlohmann_json
    blas
    lapack
  ];

  buildPhase = ''
    export FSLDIR=${fsl-base}
    export FSLCONFDIR=${fsl-base}/config
    export FSLDEVDIR=$out
    make
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib $out/include/avwutils $out/bin
    make FSLDEVDIR=$out install
    runHook postInstall
  '';

  postInstall = ''
    for f in $out/bin/fslval $out/bin/fslinfo $out/bin/fslsize $out/bin/fslchpixdim \
              $out/bin/fsledithd $out/bin/fslmodhd $out/bin/fslreorient2std $out/bin/fslswapdim; do
      [ -f "$f" ] && sed -i 's|''${FSLDIR}/bin/||g; s|\$FSLDIR/bin/||g' "$f" || true
    done
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "FSL image utilities including fslmaths, fslstats and fslhd";
    homepage = "https://git.fmrib.ox.ac.uk/fsl/avwutils";
    license = lib.licenses.fmribSoftwareLibrary;
    maintainers = with lib.maintainers; [ dinga92 ];
    platforms = lib.platforms.linux;
  };
})
