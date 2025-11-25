{
  lib,
  stdenv,
  fetchFromGitHub,
  bash,
}:

stdenv.mkDerivation rec {
  pname = "shellspec";
  version = "0.28.1";

  src = fetchFromGitHub {
    owner = "shellspec";
    repo = "shellspec";
    rev = version;
    sha256 = "1ib5qp29f2fmivwnv6hq35qhvdxz42xgjlkvy0i3qn758riyqf46";
  };

  strictDeps = true;
  buildInputs = [ bash ];
  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  checkPhase = ''
    ./shellspec --no-banner --task fixture:stat:prepare
    ./shellspec --no-banner spec --jobs "$(nproc)"
  '';

  # "Building" the script happens in Docker
  dontBuild = true;

  meta = {
    description = "Full-featured BDD unit testing framework for bash, ksh, zsh, dash and all POSIX shells";
    homepage = "https://shellspec.info/";
    changelog = "https://github.com/shellspec/shellspec/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ j0hax ];
    platforms = lib.platforms.unix;
    mainProgram = "shellspec";
  };
}
