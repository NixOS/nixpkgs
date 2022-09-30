{ stdenv, python3Packages, fetchurl, perl, gnuplot, R, gnugrep, coreutils, crystfel-headless, perlPackages, symlinkJoin }:
let attributes = import ./attributes.nix { inherit fetchurl; };
in
rec {
  gnuplot-scripts = stdenv.mkDerivation {
    name = "crystfel-gnuplot-scripts";
    version = attributes.crystfel-version;
    src = attributes.crystfel-src;
    buildInputs = [ gnuplot ];
    postPatch = ''
      sed -ie 's#gnuplot#${gnuplot}/bin/gnuplot#' scripts/fg-graph
      sed -i -e 's#gnuplot#${gnuplot}/bin/gnuplot#' -e 's#grep#${gnugrep}/bin/grep#' -e 's#paste#${coreutils}/bin/paste#'  scripts/plot-radius-resolution
    '';
    installPhase = ''
      mkdir -p $out/bin
      cp scripts/*gp $out/
      cp scripts/fg-graph $out/bin
      cp scripts/plot-radius-resolution $out/bin
    '';
  };
  r-scripts = stdenv.mkDerivation {
    name = "crystfel-r-scripts";
    version = attributes.crystfel-version;
    src = attributes.crystfel-src;
    buildInputs = [ R ];
    installPhase = ''
      mkdir -p $out/bin
      cp scripts/*.R $out/
    '';
  };
  perl-scripts = stdenv.mkDerivation {
    name = "crystfel-perl-scripts";
    version = attributes.crystfel-version;
    src = attributes.crystfel-src;
    buildInputs = [ perl ];
    installPhase = ''
      mkdir -p $out/bin
      cp scripts/alternate-stream $out/bin
      cp scripts/cif2hkl $out/bin
      cp scripts/eV-to-A $out/bin
      cp scripts/split-indexed $out/bin
      cp scripts/find-filename $out/bin
      cp scripts/hkl2hkl $out/bin
      cp scripts/indexed-filenames $out/bin
    '';
  };
  stream_grep = perlPackages.buildPerlPackage {
    pname = "crystfel-stream-grep";
    version = attributes.crystfel-version;
    src = attributes.crystfel-src;
    propagatedBuildInputs = with perlPackages; [ GetoptLongDescriptive Switch ];
    outputs = [ "out" "dev" ]; # no "devdoc"
    preConfigure = ''
      cp ${./stream_grep_Makefile_PL} Makefile.PL;
    '';
  };
  python-scripts = python3Packages.buildPythonApplication rec {
    name = "crystfel-python-scripts";
    version = attributes.crystfel-version;
    src = attributes.crystfel-src;

    postUnpack =
      let setupPy = builtins.toFile "setup.py" ''
        from distutils.core import setup

        setup(
          name="crystfel-scripts",
          version="1.0",
          scripts=[
            "scripts/detector-shift",
            "scripts/ave-peak-resolution",
            "scripts/ave-resolution",
            "scripts/clean-stream.py",
            "scripts/crystal-frame-number",
            "scripts/display-hdf5",
            "scripts/find-multiples",
            "scripts/find-pairs",
            "scripts/gaincal-to-saturation-map",
            "scripts/eiger-badmap",
            "scripts/euxfel-train-analysis",
            "scripts/sum-hdf5-files",
            "scripts/sum-peaks",
            "scripts/transfer-geom",
            "scripts/truncate-stream",
            "scripts/turbo-index-lsf",
            "scripts/Rsplit_surface.py",
            "scripts/add-beam-params",
            "scripts/plot-pr",
            "scripts/plot-pr-contourmap",
            "scripts/make-csplit",
            "scripts/move-entire-detector",
            "scripts/split-by-mask",
            "scripts/stream2sol.py",
            "scripts/peak-intensity",
            "scripts/peakogram-stream",
            "scripts/extract-geom"
          ]
        )
      '';
      in "cp ${setupPy} crystfel-${attributes.crystfel-version}/setup.py";

    propagatedBuildInputs = [ python3Packages.numpy python3Packages.matplotlib python3Packages.h5py ];
  };
  combination-scripts = stdenv.mkDerivation {
    name = "crystfel-combination-scripts";
    version = attributes.crystfel-version;
    src = attributes.crystfel-src;

    postPatch = ''
      sed -i\
        -e 's#python clean-stream.py#${python-scripts}/bin/clean-stream.py#'\
        -e 's#./alternate-stream#${perl-scripts}/bin/alternate-stream#'\
        -e 's#process_hkl#${crystfel-headless}/bin/process_hkl#'\
        -e 's#compare_hkl#${crystfel-headless}/bin/compare_hkl#'\
        -e 's#python Rsplit_surface.py#${python-scripts}/bin/Rsplit_surface.py#'\
        scripts/Rsplit_surface
      sed -i\
        -e 's#render_hkl#${crystfel-headless}/bin/render_hkl#'\
        scripts/zone-axes
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp scripts/Rsplit_surface $out/bin/
      cp scripts/zone-axes $out/bin/
    '';

  };
  all-scripts = symlinkJoin {
    name = "crystfel-scripts";

    paths = [ python-scripts perl-scripts combination-scripts stream_grep r-scripts gnuplot-scripts ];
  };
}
