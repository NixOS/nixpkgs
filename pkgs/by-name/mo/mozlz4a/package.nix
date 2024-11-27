{ lib
, stdenv
, fetchurl
, python3
, runtimeShell
}:

stdenv.mkDerivation rec {
  pname = "mozlz4a";
  version = "2022-03-19";

  src = fetchurl {
    url = "https://gist.githubusercontent.com/Tblue/62ff47bef7f894e92ed5/raw/c12fce199a97ecb214eb913cc5d762eac2e92c57/mozlz4a.py";
    hash = "sha256-Igj9u6TmV+nIuSg8gI8zD4hTb/Iiog/3aB3DDk0Lqkg=";
  };

  dontUnpack = true;

  buildInputs = [ python3 python3.pkgs.lz4 ];

  installPhase = ''
    mkdir -p "$out/bin" "$out/${python3.sitePackages}/"
    cp "${src}" "$out/${python3.sitePackages}/mozlz4a.py"

    echo "#!${runtimeShell}" >> "$out/bin/mozlz4a"
    echo "export PYTHONPATH='$PYTHONPATH'" >> "$out/bin/mozlz4a"
    echo "'${python3}/bin/python' '$out/${python3.sitePackages}/mozlz4a.py' \"\$@\"" >> "$out/bin/mozlz4a"
    chmod a+x "$out/bin/mozlz4a"
  '';

  meta = with lib; {
    description = "MozLz4a compression/decompression utility";
    license = licenses.bsd2;
    maintainers = with maintainers; [ kira-bruneau pshirshov raskin ];
    platforms = python3.meta.platforms;
    homepage = "https://gist.github.com/Tblue/62ff47bef7f894e92ed5";
    mainProgram = "mozlz4a";
  };
}
