{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitLab,
  perl,
  taktuk,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.2.2";
  pname = "kanif";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "taktuk";
    repo = "kanif";
    rev = "b6793ce4e72e6bd65f8ffaf0645a5bdd4c1c51b9"; # does not tag releases
    hash = "sha256-9xrefboBKX2eYAbxLB2ShaI7ARUkfMu9TvxCCEFH74I=";
  };

  nativeBuildInputs = [
    autoreconfHook
    perl
    taktuk
  ];

  preBuild = ''
    substituteInPlace ./kanif --replace-fail "/usr/bin/perl" "${perl}/bin/perl"
    substituteInPlace ./kanif --replace-fail '$taktuk_command = "taktuk";' '$taktuk_command = "${taktuk}/bin/taktuk";'
    # Newer pod2man requires text after =item; a bare number is rejected.
    substituteInPlace ./kanif.pod --replace-fail '=item 0' '=item B<0>'
    substituteInPlace ./kanif.pod --replace-fail '=item 1' '=item B<1>'
    substituteInPlace ./kanif.pod --replace-fail '=item 2' '=item B<2>'
    substituteInPlace ./kanif.pod --replace-fail '=item 3' '=item B<3>'
    substituteInPlace ./kanif.pod --replace-fail '=item 4' '=item B<4>'
  '';

  strictDeps = true;

  meta = {
    description = "Cluster management and administration swiss army knife";
    longDescription = ''
      Kanif is a tool for high performance computing clusters management and
      administration. It combines the main functionalities of well-known cluster
      management tools such as c3, pdsh and dsh, and mimics their syntax. It
      provides three tools to run the same command on several nodes ("parallel
      ssh", using the 'kash' command), to broadcast the copy of files or
      directories to several nodes ('kaput' command), and to gather several
      remote files or directories locally ('kaget' command). It relies on TakTuk
      for efficiency and scalability.'';
    homepage = "https://gitlab.inria.fr/taktuk/kanif";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.bzizou ];
    platforms = lib.platforms.linux;
  };

})
