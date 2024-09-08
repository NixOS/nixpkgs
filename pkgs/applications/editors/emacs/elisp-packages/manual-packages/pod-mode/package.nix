{
  lib,
  melpaBuild,
  fetchurl
}:

let
  pname = "pod-mode";
  version = "1.04";

  src = fetchurl {
    url = "mirror://cpan/authors/id/F/FL/FLORA/pod-mode-${version}.tar.gz";
    hash = "sha256-W4ejlTnBKOCQWysRzrXUQwV2gFHeFpbpKkapWT2cIPM=";
  };
in
melpaBuild {
  inherit pname version src;

  outputs = [
    "out"
    "doc"
  ];

  postInstall = ''
    mkdir -p ''${!outputDoc}/share/doc/pod-mode/
    install -Dm644 -t ''${!outputDoc}/share/doc/pod-mode/ ChangeLog README
  '';

  ignoreCompilationError = false;

  meta = {
    homepage = "https://metacpan.org/dist/pod-mode";
    description = "Major mode for editing .pod-files";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ qyliss ];
  };
}
