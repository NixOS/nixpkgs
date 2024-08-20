{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  bison,
  flex,
  readline,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cdecl";
  version = "18.2";

  src = fetchFromGitHub {
    owner = "paul-j-lucas";
    repo = "cdecl";
    rev = "refs/tags/cdecl-${finalAttrs.version}";
    hash = "sha256-6mj5M4SI0TG+N4exu3xdAqh8a98VOFtS1DbuRIYmW+Y=";
  };

  strictDeps = true;
  preConfigure = "./bootstrap";

  nativeBuildInputs = [ autoconf automake bison flex ];
  buildInputs = [ readline ];

  env = {
    NIX_CFLAGS_COMPILE = toString (
      [
        "-DBSD"
        "-DUSE_READLINE"
      ]
      ++ lib.optionals stdenv.cc.isClang [
        "-Wno-error=int-conversion"
        "-Wno-error=incompatible-function-pointer-types"
      ]
    );
    NIX_LDFLAGS = "-lreadline";
  };

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "PREFIX=${placeholder "out"}"
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/man1"
    "CATDIR=${placeholder "out"}/cat1"
  ];

  doCheck = true;
  checkTarget = "test";

  preInstall = ''
    mkdir -p $out/bin;
  '';

  outputs = [ "out" "man" ];

  meta = {
    description = "Composing and deciphering C (or C++) declarations or casts, aka ''gibberish.''";
    homepage = "https://github.com/paul-j-lucas/cdecl";
    changelog = "https://github.com/paul-j-lucas/cdecl/blob/cdecl-${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.unix;
    mainProgram = "cdecl";
  };
})
