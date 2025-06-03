{
  lib,
  stdenv,
  fetchurl,
  installShellFiles,
  libbsd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rs";
  version = "20200313";

  src = fetchurl {
    url = "https://www.mirbsd.org/MirOS/dist/mir/rs/rs-${finalAttrs.version}.tar.gz";
    hash = "sha256-kZIV3J/oWiejC/Y9VkBs+1A/n8mCAyPEvTv+daajvD8=";
  };

  nativeBuildInputs = [ installShellFiles ];

  patches = [
    # add an implementation of reallocarray() from openbsd (not available on darwin)
    ./macos-reallocarray.patch
  ];

  buildInputs = [ libbsd ];

  buildPhase = ''
    runHook preBuild

    ${stdenv.cc}/bin/cc -DNEED_STRTONUM utf8.c rs.c -o rs -lbsd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm 755 rs -t $out/bin
    installManPage rs.1

    runHook postInstall
  '';

  meta = {
    homepage = "http://www.mirbsd.org/htman/i386/man1/rs.htm";
    description = "Reshape a data array from standard input";
    mainProgram = "rs";
    longDescription = ''
      rs reads the standard input, interpreting each line as a row of blank-
      separated entries in an array, transforms the array according to the op-
      tions, and writes it on the standard output. With no arguments (argc < 2)
      it transforms stream input into a columnar format convenient for terminal
      viewing, i.e. if the length (in bytes!) of the first line is smaller than
      the display width, -et is implied, -t otherwise.

      The shape of the input array is deduced from the number of lines and the
      number of columns on the first line. If that shape is inconvenient, a more
      useful one might be obtained by skipping some of the input with the -k
      option. Other options control interpretation of the input columns.

      The shape of the output array is influenced by the rows and cols specifi-
      cations, which should be positive integers. If only one of them is a po-
      sitive integer, rs computes a value for the other which will accommodate
      all of the data. When necessary, missing data are supplied in a manner
      specified by the options and surplus data are deleted. There are options
      to control presentation of the output columns, including transposition of
      the rows and columns.
    '';
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
