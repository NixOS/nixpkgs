{
  stdenv,
  fetchFromGitHub,
  coreutils,
  autoreconfHook,
  smlnj,
}:

let
  rev = "7376cb20ba5285a6b076a73c821e4743809c1d9d";
in
stdenv.mkDerivation {
  pname = "manticore";
  version = "2019.12.03";

  src = fetchFromGitHub {
    owner = "ManticoreProject";
    repo = "manticore";
    sha256 = "17h3ar7d6145dyrm006r3gd5frk3v4apjk383n78dh4vlniv1ay2";
    inherit rev;
  };

  enableParallelBuilding = false;

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    coreutils
    smlnj
  ];

  autoreconfFlags = [
    "-Iconfig"
    "-vfi"
  ];

  unpackPhase = ''
    mkdir -p $out
    cd $out
    unpackFile $src
    mv source repo_checkout
    cd repo_checkout
    chmod u+w . -R
  '';

  postPatch = ''
    patchShebangs .
    substituteInPlace configure.ac --replace 'MANTICORE_ROOT=`pwd`' 'MANTICORE_ROOT=$out/repo_checkout'
  '';

  preInstall = "mkdir -p $out/bin";

  meta = {
    description = "Parallel, pure variant of Standard ML";
    mainProgram = "pmlc";

    longDescription = ''
      Manticore is a high-level parallel programming language aimed at
      general-purpose applications running on multi-core
      processors. Manticore supports parallelism at multiple levels:
      explicit concurrency and coarse-grain parallelism via CML-style
      constructs and fine-grain parallelism via various light-weight
      notations, such as parallel tuple expressions and NESL/Nepal-style
      parallel array comprehensions.
    '';

    homepage = "http://manticore.cs.uchicago.edu/";
  };
}
