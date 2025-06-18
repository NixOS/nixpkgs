{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  makeWrapper,
  perlPackages,
  libminc,
  octave,
  coreutils,
  minc_tools,
}:

stdenv.mkDerivation {
  pname = "minc-widgets";
  version = "unstable-2016-04-20";

  src = fetchFromGitHub {
    owner = "BIC-MNI";
    repo = "minc-widgets";
    rev = "f08b643894c81a1a2e0fbfe595a17a42ba8906db";
    sha256 = "1b9g6lf37wpp211ikaji4rf74rl9xcmrlyqcw1zq3z12ji9y33bm";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];
  buildInputs = [ libminc ];
  propagatedBuildInputs =
    (with perlPackages; [
      perl
      GetoptTabular
      MNI-Perllib
    ])
    ++ [
      octave
      coreutils
      minc_tools
    ];

  postFixup = ''
    for p in $out/bin/*; do
      wrapProgram $p --prefix PERL5LIB : $PERL5LIB --set PATH "${
        lib.makeBinPath [
          coreutils
          minc_tools
        ]
      }";
    done
  '';

  meta = with lib; {
    homepage = "https://github.com/BIC-MNI/minc-widgets";
    description = "Collection of Perl and shell scripts for processing MINC files";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license = licenses.free;
  };
}
