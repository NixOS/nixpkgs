{
  stdenv,
  lib,
  fetchFromGitHub,
  buildPackages,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "oksh";
  version = "7.5";

  src = fetchFromGitHub {
    owner = "ibara";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-r75jjH1E7/36b0ebjsZK7rAuOHEyaIta5Bi8nB4zVjo=";
  };

  strictDeps = true;

  postPatch = lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    substituteInPlace configure --replace "./conftest" "echo"
  '';

  configureFlags = [ "--no-strip" ];

  buildInputs = [ ncurses ];

  meta = with lib; {
    description = "Portable OpenBSD ksh, based on the Public Domain Korn Shell (pdksh)";
    mainProgram = "oksh";
    homepage = "https://github.com/ibara/oksh";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.all;
  };

  passthru = {
    shellPath = "/bin/oksh";
  };
}
