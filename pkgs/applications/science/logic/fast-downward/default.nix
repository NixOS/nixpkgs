{ stdenv, lib, fetchhg, cmake, which, python3, osi, cplex }:

stdenv.mkDerivation {
  version = "19.12";
  pname = "fast-downward";

  src = fetchhg {
    url = "http://hg.fast-downward.org/";
    rev = "41688a4f16b3";
    sha256 = "08m4k1mkx4sz7c2ab7xh7ip6b67zxv7kl68xrvwa83xw1yigqkna";
  };

  nativeBuildInputs = [ cmake which ];
  buildInputs = [ python3 python3.pkgs.wrapPython osi ];

  cmakeFlags =
    lib.optional osi.withCplex [ "-DDOWNWARD_CPLEX_ROOT=${cplex}/cplex" ];

  configurePhase = ''
    python build.py release
  '';

  postPatch = ''
    # Needed because the package tries to be too smart.
    export CC="$(which $CC)"
    export CXX="$(which $CXX)"
  '';

  installPhase = ''
    install -Dm755 builds/release/bin/downward $out/libexec/fast-downward/downward
    cp -r builds/release/bin/translate $out/libexec/fast-downward/
    install -Dm755 fast-downward.py $out/bin/fast-downward
    mkdir -p $out/${python3.sitePackages}
    cp -r driver $out/${python3.sitePackages}

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

    substituteInPlace $out/${python3.sitePackages}/driver/arguments.py \
      --replace 'args.build = "release"' "args.build = \"$out/libexec/fast-downward\""
  '';

  meta = with lib; {
    description = "A domain-independent planning system";
    homepage = "http://www.fast-downward.org/";
    license = licenses.gpl3Plus;
    platforms = with platforms; (linux ++ darwin);
    maintainers = with maintainers; [ abbradar ];
  };
}
