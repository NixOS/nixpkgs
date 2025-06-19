{
  lib,
  stdenv,
  fetchFromGitHub,
  attr,
  acl,
  libcap,
  liburing,
  oniguruma,
}:

stdenv.mkDerivation rec {
  pname = "bfs";
  version = "4.0.7";

  src = fetchFromGitHub {
    repo = "bfs";
    owner = "tavianator";
    rev = version;
    hash = "sha256-/Xj8zfl/2gjKd+/V2QS/i6Dw4AO0VudnYturWi68kbk=";
  };

  buildInputs =
    [ oniguruma ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      acl
      attr
      libcap
      liburing
    ];

  configureFlags = [ "--enable-release" ];
  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Breadth-first version of the UNIX find command";
    longDescription = ''
      bfs is a variant of the UNIX find command that operates breadth-first rather than
      depth-first. It is otherwise intended to be compatible with many versions of find.
    '';
    homepage = "https://github.com/tavianator/bfs";
    license = licenses.bsd0;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      yesbox
      cafkafk
    ];
    mainProgram = "bfs";
  };
}
