{
  lib,
  stdenv,
  meson,
  ninja,
  fetchFromGitHub,
  which,
  python3,
  fetchpatch,
  libiconv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ksh";
  version = "2020.0.0";

  src = fetchFromGitHub {
    owner = "att";
    repo = "ast";
    hash = "sha256-sphfY/hZ028722clJDBiQn8fOrDOnJbTegPgCy34vTE=";
    tag = finalAttrs.version;
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/att/ast/commit/11983a71f5e29df578b7e2184400728b4e3f451d.patch";
      hash = "sha256-e45HZPnFyQ6YVyFzcA74w+Jhk9BO7bDkfReLTRgqJdk=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    which
    python3
  ];

  buildInputs = [ libiconv ];

  strictDeps = true;

  meta = {
    description = "KornShell Command And Programming Language";
    longDescription = ''
      The KornShell language was designed and developed by David G. Korn at
      AT&T Bell Laboratories. It is an interactive command language that
      provides access to the UNIX system and to many other systems, on the
      many different computers and workstations on which it is implemented.
    '';
    homepage = "https://github.com/att/ast";
    license = lib.licenses.cpl10;
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "ksh";
    platforms = lib.platforms.all;
  };

  passthru = {
    shellPath = "/bin/ksh";
  };
})
