{
  lib,
  stdenv,
  fetchFromGitLab,
  makeWrapper,
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
  python3Packages,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fsl-avwutils";
  version = "2209.6";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitLab {
    domain = "git.fmrib.ox.ac.uk";
    owner = "fsl";
    repo = "avwutils";
    rev = finalAttrs.version;
    hash = "sha256-qtvVuERT+oqiAx1BY/o7jv7hZ+a0ILw+kO52XgYpmlQ=";
  };

  nativeBuildInputs = [ makeWrapper ];

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

  phases = [
    "unpackPhase"
    "patchPhase"
    "configurePhase"
    "buildPhase"
    "installPhase"
    "fixupPhase"
    "checkPhase"
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
              $out/bin/fsledithd $out/bin/fslmodhd $out/bin/fslreorient2std $out/bin/fslswapdim \
              $out/bin/avw2fsl $out/bin/fsladd; do
      [ -f "$f" ] || continue
      sed -i 's|''${FSLDIR}/bin/||g; s|\$FSLDIR/bin/||g' "$f"
      wrapProgram "$f" \
        --set-default FSLOUTPUTTYPE NIFTI_GZ \
        --prefix PATH : $out/bin
      sed -i "1s|.*|#!${stdenv.shell}|" "$(dirname $f)/.$(basename $f)-wrapped"
    done

    for f in $out/bin/*; do
      [[ "$f" == *-wrapped ]] && continue
      head -1 "$f" 2>/dev/null | grep -q '^#!' && continue  # already handled above
      wrapProgram "$f" --set-default FSLOUTPUTTYPE NIFTI_GZ
    done
  '';

  passthru.updateScript = nix-update-script { };

  doCheck = true;

  nativeCheckInputs = [
    python3Packages.nibabel
    python3Packages.numpy
    python3Packages.fslpy
  ];

  checkPhase = ''
    export FSLOUTPUTTYPE=NIFTI_GZ
    export FSLDIR=${fsl-base}
    export PATH=$out/bin:$PATH
    tmpdir=$(mktemp -d)
    for test in fslmaths fslchpixdim fslcomplex fslcreatehd fix_orient; do
      echo "running $test tests..."
      python3 ${finalAttrs.src}/tests/$test/feedsRun $tmpdir
    done
  '';

  meta = {
    description = "FSL image utilities including fslmaths, fslstats and fslhd";
    homepage = "https://git.fmrib.ox.ac.uk/fsl/avwutils";
    license = lib.licenses.fmribSoftwareLibrary;
    maintainers = with lib.maintainers; [ dinga92 ];
    platforms = lib.platforms.linux;
  };
})
