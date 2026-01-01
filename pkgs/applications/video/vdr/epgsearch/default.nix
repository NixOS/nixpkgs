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
<<<<<<< HEAD
  version = "2.4.5";
=======
  version = "2.4.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    repo = "vdr-plugin-epgsearch";
    owner = "vdr-projects";
<<<<<<< HEAD
    sha256 = "sha256-ERHy6ks5evYmOUoTXNd63ETIA2PyR67VZ7CXR6kn7x4=";
=======
    sha256 = "sha256-hHTb6MbN18gNiovX1BKR6ldxxRDeDXJt4kNm722phRk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
