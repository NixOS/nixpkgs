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
  version = "4.1";

  src = fetchFromGitHub {
    repo = "bfs";
    owner = "tavianator";
    tag = version;
    hash = "sha256-+hGxdsk9MU5MVvvx3C2cqomboNxD0UZ5y7t84fAwfqs=";
  };

  buildInputs = [
    oniguruma
  ]
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
