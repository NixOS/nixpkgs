{ lib
, stdenv
, fetchFromSourcehut
, makeBinaryWrapper
, curlMinimal
, mandoc
, ncurses
, nim
, pandoc
, pkg-config
, zlib
, unstableGitUpdater
, libseccomp
, replaceVars
}:

stdenv.mkDerivation {
  pname = "chawan";
  version = "0-unstable-2025-01-06";

  src = fetchFromSourcehut {
    owner = "~bptato";
    repo = "chawan";
    rev = "30a933adb2bade2ceee08a9b36371cecf554d648";
    hash = "sha256-EepSEN66GTdWfCSiR/p69pN5bvTEiUFOMErCxedrq+g=";
    fetchSubmodules = true;
  };

  patches = [ ./mancha-augment-path.diff ];

  # Include chawan's man pages in mancha's search path
  postPatch = ''
    # As we need the $out reference, we can't use `replaceVars` here.
    substituteInPlace adapter/protocol/man.nim \
      --replace-fail '@out@' "$out"
  '';

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optional stdenv.cc.isClang "-Wno-error=implicit-function-declaration"
  );

  nativeBuildInputs = [
    makeBinaryWrapper
    nim
    pandoc
    pkg-config
  ];

  buildInputs = [
    curlMinimal
    libseccomp
    ncurses
    zlib
  ];

  buildFlags = [ "all" "manpage" ];
  installFlags = [
    "DESTDIR=$(out)"
    "PREFIX=/"
  ];

  postInstall =
  let
    makeWrapperArgs = ''
      --set MANCHA_CHA $out/bin/cha \
      --set MANCHA_MAN ${mandoc}/bin/man
    '';
  in
  ''
    wrapProgram $out/bin/cha ${makeWrapperArgs}
    wrapProgram $out/bin/mancha ${makeWrapperArgs}
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Lightweight and featureful terminal web browser";
    homepage = "https://sr.ht/~bptato/chawan/";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ jtbx ];
    mainProgram = "cha";
    broken = stdenv.hostPlatform.isDarwin; # pending PR #292043
  };
}
