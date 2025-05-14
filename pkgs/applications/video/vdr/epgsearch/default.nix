{
  lib,
  stdenv,
  fetchFromGitHub,
  vdr,
  util-linux,
  groff,
  perl,
  pcre,
}:
stdenv.mkDerivation rec {
  pname = "vdr-epgsearch";
  version = "2.4.3";

  src = fetchFromGitHub {
    repo = "vdr-plugin-epgsearch";
    owner = "vdr-projects";
    sha256 = "sha256-hOMISobeEt/jB4/18t5ZeN+EcPHhm8Jz8Kar72KYS3E=";
    rev = "v${version}";
  };

  postPatch = ''
    for f in *.sh; do
      patchShebangs "$f"
    done
  '';

  nativeBuildInputs = [
    perl # for pod2man and pos2html
    util-linux
    groff
  ];

  buildInputs = [
    vdr
    pcre
  ];

  buildFlags = [
    "SENDMAIL="
    "REGEXLIB=pcre"
  ];

  installFlags = [
    "DESTDIR=$(out)"
  ];

  outputs = [
    "out"
    "man"
  ];

  meta = {
    inherit (src.meta) homepage;
    description = "Searchtimer and replacement of the VDR program menu";
    mainProgram = "createcats";
    maintainers = [ lib.maintainers.ck3d ];
    license = lib.licenses.gpl2;
    inherit (vdr.meta) platforms;
  };
}
