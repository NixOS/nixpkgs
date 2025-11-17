{
  lib,
  stdenv,
  cmake,
  fetchurl,
  fetchFromGitHub,
  pkg-config,
  libffi,
  pandoc,
  pcre,
  json_c,
  boehmgc,
}:

let
  version = "0.2.16";
  peg-homepage = "http://piumarta.com/software/peg/";
  peg-pname = "peg";
  peg-version = "0.1.19";
  # peg v0.1.20 (latest) causes a compilation error against syntax.legs
  # ref: https://github.com/ngs-lang/ngs/issues/662
  peg-0-1-19 = stdenv.mkDerivation {
    pname = peg-pname;
    version = peg-version;
    src = fetchurl {
      url = "${peg-homepage}/${peg-pname}-${peg-version}.tar.gz";
      sha256 = "sha256-ABPdg6Zzl3hEWmS87T10ufUMB1U/hupDMzrl+rXCu7Q=";
    };
    preBuild = "makeFlagsArray+=( PREFIX=$out )";
    meta = {
      homepage = peg-homepage;
      license = lib.licenses.mit;
    };
  };
  src = fetchFromGitHub {
    owner = "ngs-lang";
    repo = "ngs";
    rev = "refs/tags/v${version}";
    hash = "sha256-hIjhy62HB5WyT3VUZP+kZWhE9PdP1cT4lGMEQiFIZdI=";
  };
in
stdenv.mkDerivation {
  pname = "ngs";
  inherit version src;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libffi
    pandoc
    peg-0-1-19
    pcre
    json_c
    boehmgc
  ];

  postPatch = ''
    patchShebangs build-scripts
  '';

  meta = {
    description = "Next Generation Shell (NGS)";
    homepage = "https://ngs-lang.org/";
    changelog = "https://github.com/ngs-lang/ngs/releases/tag/${src.rev}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    mainProgram = "ngs";
    maintainers = with lib.maintainers; [ momeemt ];
  };
}
