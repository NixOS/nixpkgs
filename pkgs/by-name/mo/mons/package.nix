{
  coreutils,
  fetchFromGitHub,
  gawk,
  gnugrep,
  gnused,
  help2man,
  lib,
  makeWrapper,
  stdenvNoCC,
  xrandr,
}:

stdenvNoCC.mkDerivation {
  pname = "mons";
  version = "unstable-2020-03-20";

  src = fetchFromGitHub {
    owner = "Ventto";
    repo = "mons";
    rev = "375bbba3aa700c8b3b33645a7fb70605c8b0ff0c";
    hash = "sha256:19r5y721yrxhd9jp99s29jjvm0p87vl6xfjlcj38bljq903f21cl";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    help2man
    makeWrapper
  ];

  postPatch = ''
    # Bake in xrandr's path; the upstream `command -p[v]` lookups use a
    # sanitized PATH that doesn't include nix-store paths.
    substituteInPlace mons.sh \
      --replace-fail 'XRANDR="$(command -pv xrandr)"' 'XRANDR="${xrandr}/bin/xrandr"' \
      --replace-fail "command -vp xrandr >/dev/null 2>&1 || { echo 'xrandr: command not found.'; exit 1; }" ":"
  '';

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  postFixup = ''
    wrapProgram $out/bin/mons \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gawk
          gnugrep
          gnused
          xrandr
        ]
      }
  '';

  meta = {
    description = "POSIX Shell script to quickly manage 2-monitors display";
    homepage = "https://github.com/Ventto/mons.git";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ thiagokokada ];
    platforms = lib.platforms.unix;
    mainProgram = "mons";
  };
}
