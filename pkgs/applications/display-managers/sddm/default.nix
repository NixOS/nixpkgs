{
  lib,
  callPackage,
  runCommand,
  wrapQtAppsHook,
<<<<<<< HEAD
  sddm-unwrapped,
=======
  unwrapped ? callPackage ./unwrapped.nix { },
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  extraPackages ? [ ],
}:
runCommand "sddm-wrapped"
  {
<<<<<<< HEAD
    inherit (sddm-unwrapped) version outputs;

    buildInputs = sddm-unwrapped.buildInputs ++ extraPackages;
=======
    inherit (unwrapped) version outputs;

    buildInputs = unwrapped.buildInputs ++ extraPackages;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    nativeBuildInputs = [ wrapQtAppsHook ];

    strictDeps = true;

    passthru = {
<<<<<<< HEAD
      unwrapped = sddm-unwrapped;
      inherit (sddm-unwrapped.passthru) tests;
    };

    meta = sddm-unwrapped.meta;
=======
      inherit unwrapped;
      inherit (unwrapped.passthru) tests;
    };

    meta = unwrapped.meta;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  }
  ''
    mkdir -p $out/bin

<<<<<<< HEAD
    cd ${sddm-unwrapped}
=======
    cd ${unwrapped}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    for i in *; do
      if [ "$i" == "bin" ]; then
        continue
      fi
<<<<<<< HEAD
      ln -s ${sddm-unwrapped}/$i $out/$i
    done

    for i in bin/*; do
      makeQtWrapper ${sddm-unwrapped}/$i $out/$i --set SDDM_GREETER_DIR $out/bin
    done

    mkdir -p $man
    ln -s ${lib.getMan sddm-unwrapped}/* $man/
=======
      ln -s ${unwrapped}/$i $out/$i
    done

    for i in bin/*; do
      makeQtWrapper ${unwrapped}/$i $out/$i --set SDDM_GREETER_DIR $out/bin
    done

    mkdir -p $man
    ln -s ${lib.getMan unwrapped}/* $man/
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ''
