# One of the four libraries reproto needs, private to it (spec 0411 S6):
# built from reproto's own source, at its version, so that one update moves
# all five.
{
  lib,
  buildPythonPackage,
  setuptools,
  src,
  version,
}:

buildPythonPackage {
  pname = "tree-sitter-textproto";
  inherit src version;
  pyproject = true;
  __structuredAttrs = true;

  sourceRoot = "${src.name}/reproto/tree-sitter-textproto";

  build-system = [ setuptools ];

  # There are no tests
  doCheck = false;

  pythonImportsCheck = [ "tree_sitter_textproto" ];

  meta = {
    description = "Textproto grammar for tree-sitter";
    longDescription = ''
      The protobuf text format grammar prototools uses, modified from
      PorterAtGoogle's tree-sitter-textproto to also parse a bare field
      number as a field name.
    '';
    homepage = "https://github.com/douzebis/prototools";
    license = with lib.licenses; [
      isc
      mit
    ];
    maintainers = with lib.maintainers; [ douzebis ];
  };
}
