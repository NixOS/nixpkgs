{
  lib,
  buildDunePackage,
  opam-format,
  curl,
}:

buildDunePackage {
  pname = "opam-repository";

  inherit (opam-format) src version;

  propagatedBuildInputs = [ opam-format ];

  configureFlags = [ "--disable-checks" ];

  meta = opam-format.meta // {
    description = "OPAM repository and remote sources handling, including curl/wget, rsync, git, mercurial, darcs backends";
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
}
