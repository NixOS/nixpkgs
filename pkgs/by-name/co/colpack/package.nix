{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {

  pname = "ColPack";
  version = "1.0.10";

  src = fetchFromGitHub {
    owner = "CSCsw";
    repo = "ColPack";
    rev = "v" + finalAttrs.version;
    hash = "sha256-mb4BYJJn3YzaWVR4auZNvP7oB/qAmSHMlbkCknzeBdw=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [
    "--enable-openmp=${lib.boolToYesNo stdenv.hostPlatform.isLinux}"
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

  meta = {
    description = "Package comprising of implementations of algorithms for
    vertex coloring and derivative computation";
    homepage = "https://cscapes.cs.purdue.edu/coloringpage/software.htm#functionalities";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ edwtjo ];
  };
})
