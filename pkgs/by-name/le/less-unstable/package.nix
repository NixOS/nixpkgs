{
  autoreconfHook,
  fetchFromGitHub,
  less,
  perl,
}:

less.overrideAttrs (finalAttrs: {
  pname = "${less.pname}-unstable";
  version = "696";

  src = fetchFromGitHub {
    owner = "gwsw";
    repo = "less";
    tag = "v${finalAttrs.version}";
    hash = "sha256-//et0thRbNtzlIcZEKx0if33MKIZ+jEjdUHxpaJkTWo=";
  };

  sourceRoot = "source";

  nativeBuildInputs = [
    autoreconfHook
    perl
  ];

  preBuild = ''
    gcc --output buildgen buildgen.c
    cat *.c | ./buildgen funcs >funcs.h
    perl mkhelp.pl less.hlp >help.c
    perl mkhelp.pl less.hlp >less.nro
    substituteInPlace less{key,echo}.nro.VER \
      --replace-fail '@@VERSION@@' "${finalAttrs.version}" \
      --replace-fail '@@DATE@@' "$(date +%Y-%m-%d)"
    cp lesskey.nro.VER lesskey.nro
    cp lessecho.nro.VER lessecho.nro
  '';
})
