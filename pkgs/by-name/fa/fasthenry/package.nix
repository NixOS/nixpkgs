{
  stdenv,
  fetchFromGitHub,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "fasthenry";
  # later versions are Windows only ports
  # nixpkgs-update: no auto update
  version = "3.0.1";

  # we don't use the original MIT code at
  # https://www.rle.mit.edu/cpg/research_codes.htm
  # since the FastFieldSolvers S.R.L. version includes
  # a couple of bug fixes
  src = fetchFromGitHub {
    owner = "ediloren";
    repo = "FastHenry2";
    rev = "R${version}";
    sha256 = "017kcri69zhyhii59kxj1ak0gyfn7jf0qp6p2x3nnljia8njdkcc";
  };

  dontConfigure = true;

  preBuild =
    ''
      makeFlagsArray=(
        CC="gcc"
        RM="rm"
        SHELL="sh"
        "all"
      )
    ''
    + (
      if stdenv.hostPlatform.isx86_64 then
        ''
          makeFlagsArray+=(
            CFLAGS="-fcommon -O -DFOUR -m64"
          );
        ''
      else
        ''
            makeFlagsArray+=(
              CFLAGS="-fcommon -O -DFOUR"
          );
        ''
    );

  installPhase = ''
    mkdir -p $out/bin
    cp -r bin/* $out/bin/
    mkdir -p $out/share/doc/${pname}-${version}
    cp -r doc/* $out/share/doc/${pname}-${version}
    mkdir -p $out/share/${pname}-${version}/examples
    cp -r examples/* $out/share/${pname}-${version}/examples
  '';

  meta = {
    description = "Multipole-accelerated inductance analysis program";
    longDescription = ''
      Fasthenry is an inductance extraction program based on a
      multipole-accelerated algorithm.'';
    homepage = "https://www.fastfieldsolvers.com/fasthenry2.htm";
    license = lib.licenses.lgpl2Only;
    maintainers = with lib.maintainers; [ fbeffa ];
    platforms = lib.intersectLists (lib.platforms.linux) (lib.platforms.x86_64 ++ lib.platforms.x86);
  };
}
