{
  lib,
  stdenv,
  fetchFromCodeberg,
  libjodycode,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jdupes";
  version = "1.31.3";

  src = fetchFromCodeberg {
    owner = "jbruchon";
    repo = "jdupes";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Vm+t1yFLYc77uSRa5N46UTUqT6mQ++4lGC1Z/wVa0jE=";
    # Unicode file names lead to different checksums on HFS+ vs. other
    # filesystems because of unicode normalisation. The testdir
    # directories have such files and will be removed.
    postFetch = "rm -r $out/testdir";
  };

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
