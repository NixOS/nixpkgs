{ lib, stdenv, fetchurl, python3Packages, zlib, bash }:

let
  pythonPackages = python3Packages;
  inherit (pythonPackages) python;
in

pythonPackages.buildPythonApplication rec {
  pname = "quast";
  version = "5.0.2";

  src = fetchurl {
    url = "https://github.com/ablab/quast/releases/download/${pname}_${version}/${pname}-${version}.tar.gz";
    sha256 = "13ml8qywbb4cc7wf2x7z5mz1rjqg51ab8wkizwcg4f6c40zgif6d";
  };

  pythonPath = with pythonPackages; [ simplejson joblib setuptools matplotlib ];

  buildInputs = [ zlib ] ++ pythonPath;

  dontConfigure = true;

  dontBuild = true;

  installPhase = ''
    substituteInPlace quast_libs/bedtools/Makefile \
      --replace "/bin/bash" "${bash}/bin/bash"
    mkdir -p "$out/${python.sitePackages}"
    export PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH"
    ${python.pythonForBuild.interpreter} setup.py install \
      --install-lib=$out/${python.sitePackages} \
      --prefix="$out"
  '';

   postFixup = ''
   for file in $(find $out -type f -type f -perm /0111); do
       old_rpath=$(patchelf --print-rpath $file) && \
       patchelf --set-rpath $old_rpath:${stdenv.cc.cc.lib}/lib $file || true
   done
   # Link to the master program
   ln -s $out/bin/quast.py $out/bin/quast
  '';

  dontPatchELF = true;

  # Tests need to download data files, so manual run after packaging is needed
  doCheck = false;

  meta = with lib ; {
    description = "Evaluates genome assemblies by computing various metrics";
    homepage = "https://github.com/ablab/quast";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryNativeCode  # source bundles binary dependencies
    ];
    license = licenses.gpl2;
    maintainers = [ maintainers.bzizou ];
    platforms = platforms.all;
  };
}
