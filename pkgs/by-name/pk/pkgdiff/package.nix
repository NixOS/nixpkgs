{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  perl,
  wdiff,
}:

stdenv.mkDerivation rec {
  version = "1.8";
  pname = "pkgdiff";

  src = fetchFromGitHub {
    owner = "lvc";
    repo = "pkgdiff";
    rev = version;
    sha256 = "sha256-/xhORi/ZHC4B2z6UYPOvDzfgov1DcozRjX0K1WYrqXM=";
  };

  buildInputs = [ perl ];
  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  makeFlags = [ "prefix=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/pkgdiff --prefix PATH : ${lib.makeBinPath [ wdiff ]}
  '';

  meta = with lib; {
    description = "Tool for visualizing changes in Linux software packages";
    homepage = "https://lvc.github.io/pkgdiff/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ sweber ];
    platforms = platforms.unix;
    mainProgram = "pkgdiff";
  };
}
