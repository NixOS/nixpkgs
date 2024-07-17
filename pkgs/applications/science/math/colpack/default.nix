{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {

  pname = "ColPack";
  version = "1.0.10";

  src = fetchFromGitHub {
    owner = "CSCsw";
    repo = pname;
    rev = "v" + version;
    sha256 = "1p05vry940mrjp6236c0z83yizmw9pk6ly2lb7d8rpb7j9h03glr";
  };

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [
    "--enable-openmp=${if stdenv.isLinux then "yes" else "no"}"
    "--enable-examples=no"
  ];

  postInstall = ''
    # Remove libtool archive
    rm $out/lib/*.la

    # Remove compiled examples (Basic examples get compiled anyway)
    rm -r $out/examples

    # Copy the example sources (Basic tree contains scripts and object files)
    mkdir -p $out/share/ColPack/examples/Basic
    cp SampleDrivers/Basic/*.cpp $out/share/ColPack/examples/Basic
    cp -r SampleDrivers/Matrix* $out/share/ColPack/examples
  '';

  meta = with lib; {
    description = "A package comprising of implementations of algorithms for
    vertex coloring and derivative computation";
    homepage = "https://cscapes.cs.purdue.edu/coloringpage/software.htm#functionalities";
    license = licenses.lgpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ edwtjo ];
  };
}
