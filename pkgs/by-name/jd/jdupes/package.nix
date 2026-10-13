{
  lib,
  stdenv,
  fetchFromCodeberg,
  fetchpatch2,
  libjodycode,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jdupes";
  version = "1.31.1";

  src = fetchFromCodeberg {
    owner = "jbruchon";
    repo = "jdupes";
    rev = "v${finalAttrs.version}";
    hash = "sha256-I1DtJokp43K9nZt73od4esK705nosIWEHLw4lydufbE=";
    # Unicode file names lead to different checksums on HFS+ vs. other
    # filesystems because of unicode normalisation. The testdir
    # directories have such files and will be removed.
    postFetch = "rm -r $out/testdir";
  };

  patches = [
    (fetchpatch2 {
      name = "use-stat-time-macros-for-compatibility-reasons.patch";
      url = "https://codeberg.org/jbruchon/jdupes/commit/464f72c82f2ce81dd33bfb5381f1bcf148da4091.patch";
      hash = "sha256-/B6iNAG3Fsmot5MGSBMs99QnAc/bFZJjPtnbiq21QZg=";
    })
  ];

  buildInputs = [ libjodycode ];

  dontConfigure = true;

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    # don't link with ../libjodycode
    "IGNORE_NEARBY_JC=1"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "ENABLE_DEDUPE=1"
    "STATIC_DEDUPE_H=1"
  ]
  ++ lib.optionals stdenv.cc.isGNU [ "HARDEN=1" ];

  enableParallelBuilding = true;

  doCheck = false; # broken Makefile, the above also removes tests

  postInstall = ''
    install -Dm444 -t $out/share/doc/jdupes CHANGES.txt LICENSE.txt README.md
  '';

  meta = {
    description = "Powerful duplicate file finder and an enhanced fork of 'fdupes'";
    longDescription = ''
      jdupes is a program for identifying and taking actions upon
      duplicate files. This fork known as 'jdupes' is heavily modified
      from and improved over the original.
    '';
    homepage = "https://codeberg.org/jbruchon/jdupes";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "jdupes";
  };
})
