{
  wsjtx,
  fetchgit,
  qt5,
  lib,
}:
wsjtx.overrideAttrs (
  finalAttrs: old: {
    pname = "jtdx";
    version = "159";
    src = fetchgit {
      url = "https://github.com/jtdx-project/jtdx.git";
      tag = finalAttrs.version;
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
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.linux;
    };
  }
)
