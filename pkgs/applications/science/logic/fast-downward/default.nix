{ stdenv, lib, fetchhg, cmake, which, python3, osi, cplex }:

stdenv.mkDerivation {
  name = "fast-downward-2019-05-13";

  src = fetchhg {
    url = "http://hg.fast-downward.org/";
    rev = "090f5df5d84a";
    sha256 = "14pcjz0jfzx5269axg66iq8js7lm2w3cnqrrhhwmz833prjp945g";
  };

  nativeBuildInputs = [ cmake which ];
  buildInputs = [ python3 python3.pkgs.wrapPython osi ];

  cmakeFlags =
    lib.optional osi.withCplex [ "-DDOWNWARD_CPLEX_ROOT=${cplex}/cplex" ];

  enableParallelBuilding = true;

  postPatch = ''
    cd src
    # Needed because the package tries to be too smart.
    export CC="$(which $CC)"
    export CXX="$(which $CXX)"
  '';

  installPhase = ''
    install -Dm755 bin/downward $out/libexec/fast-downward/downward
    cp -r ../translate $out/libexec/fast-downward/
    install -Dm755 ../../fast-downward.py $out/bin/fast-downward
    mkdir -p $out/${python3.sitePackages}
    cp -r ../../driver $out/${python3.sitePackages}

    wrapPythonProgramsIn $out/bin "$out $pythonPath"
    wrapPythonProgramsIn $out/libexec/fast-downward/translate "$out $pythonPath"
    # Because fast-downward calls `python translate.py` we need to return wrapped scripts back.
    for i in $out/libexec/fast-downward/translate/.*-wrapped; do
      name="$(basename "$i")"
      name1="''${name#.}"
      name2="''${name1%-wrapped}"
      dir="$(dirname "$i")"
      dest="$dir/$name2"
      echo "Moving $i to $dest"
      mv "$i" "$dest"
    done
  '';

  meta = with stdenv.lib; {
    description = "A domain-independent planning system";
    homepage = "http://www.fast-downward.org/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
