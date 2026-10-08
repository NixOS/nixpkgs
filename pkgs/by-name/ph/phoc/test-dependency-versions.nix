{
  lib,
  runCommand,
  yq-go,
  phoc,
  gvdb,
}:

runCommand "phoc-test-dependency-versions" { } ''
  phoc_wants_gvdb_revision="$('${lib.getExe yq-go}' --input-format ini --output-format ini '.wrap-git.revision' '${phoc.src}/subprojects/gvdb.wrap')"
  phoc_gets_gvdb_revision='${gvdb.rev}'

  if [ "$phoc_wants_gvdb_revision" != "$phoc_gets_gvdb_revision" ]; then
    echo "Wrong GVDB version! Phoc wants GVDB Git revision $phoc_wants_gvdb_revision but we're providing $phoc_gets_gvdb_revision."
    exit 1
  fi
  touch "$out"
''
