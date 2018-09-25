{ openblasCompat
, writeTextFile
, name
}:

writeTextFile {
  name = "openblas-${name}-pc-${openblasCompat.version}";
  destination = "/lib/pkgconfig/${name}.pc";
  text = ''
    Name: ${name}
    Version: ${openblasCompat.version}

    Description: ${name} for SageMath, provided by the OpenBLAS package.
    Cflags: -I${openblasCompat}/include
    Libs: -L${openblasCompat}/lib -lopenblas
  '';
}
