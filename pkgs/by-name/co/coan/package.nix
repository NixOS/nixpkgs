{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  perl,
}:

stdenv.mkDerivation rec {
  version = "6.0.1";
  pname = "coan";

  src = fetchurl {
    url = "mirror://sourceforge/project/coan2/v${version}/${pname}-${version}.tar.gz";
    sha256 = "1d041j0nd1hc0562lbj269dydjm4rbzagdgzdnmwdxr98544yw44";
  };

  patches = [
    # fix compile error in configure.ac
    ./fix-big-endian-config-check.diff
  ];

  nativeBuildInputs = [
    autoreconfHook
    perl
  ];

  configureFlags = [ "CXXFLAGS=-std=c++11" ];

  enableParallelBuilding = true;

  postInstall = ''
    mv -v $out/share/man/man1/coan.1.{1,gz}
  '';

  meta = with lib; {
    description = "C preprocessor chainsaw";
    mainProgram = "coan";
    longDescription = ''
      A software engineering tool for analysing preprocessor-based
      configurations of C or C++ source code. Its principal use is to simplify
      a body of source code by eliminating any parts that are redundant with
      respect to a specified configuration. Dead code removal is an
      application of this sort.
    '';
    homepage = "https://coan2.sourceforge.net/";
    license = licenses.bsd3;
    platforms = platforms.all;
    # The last successful Darwin Hydra build was in 2024
    broken = stdenv.hostPlatform.isDarwin;
  };
}
