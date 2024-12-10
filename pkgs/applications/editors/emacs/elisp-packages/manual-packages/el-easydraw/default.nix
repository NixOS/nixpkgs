{
  lib,
  melpaBuild,
  fetchFromGitHub,
  writeText,
  unstableGitUpdater,
  gzip,
}:

let
  rev = "de68851724072c6695e675f090b33a8abec040c9";
in
melpaBuild {
  pname = "edraw";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "misohena";
    repo = "el-easydraw";
    inherit rev;
    hash = "sha256-l9i+HCRKnKiDqID+bfAOPE7LpVBZp1AOPkceX8KbDXM=";
  };

  commit = rev;

  packageRequires = [ gzip ];

  recipe = writeText "recipe" ''
    (edraw
      :repo "misohena/el-easydraw"
      :fetcher github
      :files
      ("*.el"
       "msg"))
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/misohena/el-easydraw";
    description = "Embedded drawing tool for Emacs";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ brahyerr ];
    platforms = lib.platforms.all;
  };
}
