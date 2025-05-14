{
  lib,
  stdenv,
  fetchFromGitHub,
  bmake,
  docbook_xsl,
  libxslt,
}:

stdenv.mkDerivation rec {
  pname = "libfsm";
  version = "0.1pre2987_${builtins.substring 0 8 src.rev}";

  src = fetchFromGitHub {
    owner = "katef";
    repo = "libfsm";
    rev = "087e3389ad2cd5e5c40caeb40387e632567d7258";
    hash = "sha256-XWrZxnRbMB609l+sYFf8VsXy3NxqBsBPUrHgKLIyu/I=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    bmake
    docbook_xsl
    libxslt # xsltproc
  ];
  enableParallelBuilding = true;
  enableParallelInstalling = false;

  # note: build checks value of '$CC' to add some extra cflags, but we don't
  # necessarily know which 'stdenv' someone chose, so we leave it alone (e.g.
  # if we use stdenv vs clangStdenv, we don't know which, and CC=cc in all
  # cases.) it's unclear exactly what should be done if we want those flags,
  # but the defaults work fine.
  makeFlags = [
    "-r"
    "PREFIX=$(out)"
  ];

  # fix up multi-output install. we also have to fix the pkg-config libdir
  # file; it uses prefix=$out; libdir=${prefix}/lib, which is wrong in
  # our case; libdir should really be set to the $lib output.
  postInstall = ''
    mkdir -p $lib $dev/lib

    mv $out/lib             $lib/lib
    mv $out/include         $dev/include
    mv $out/share/pkgconfig $dev/lib/pkgconfig
    rmdir $out/share

    for x in libfsm.pc libre.pc; do
      substituteInPlace "$dev/lib/pkgconfig/$x" \
        --replace 'libdir=''${prefix}/lib' "libdir=$lib/lib"
    done
  '';

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  meta = with lib; {
    description = "DFA regular expression library & friends";
    homepage = "https://github.com/katef/libfsm";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
