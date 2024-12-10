{
  wsjtx,
  fetchgit,
  qt5,
  lib,
}:
wsjtx.overrideAttrs (old: {
  name = "jtdx";
  version = "unstable-2022-03-01";
  src = fetchgit {
    url = "https://github.com/jtdx-project/jtdx.git";
    rev = "2a0e2bea8c66c9ca94d2ea8034cf83a68cfa40eb";
    hash = "sha256-5KlFBlzG3hKFFGO37c+VN+FvZKSnTQXvSorB+Grns8w=";
  };
  buildInputs = old.buildInputs ++ [ qt5.qtwebsockets ];
  meta = {
    description = "wsjtx fork with some extra features";
    maintainers = with lib.maintainers; [
      matthewcroughan
      sarcasticadmin
      pkharvey
    ];
    homepage = "https://github.com/jtdx-project/jtdx";
  };
})
