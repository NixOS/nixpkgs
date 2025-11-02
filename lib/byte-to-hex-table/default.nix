lib:
let
  dir = ./.;
  dirListing = builtins.readDir dir;
  getFileContents = name: value: builtins.readFile "${dir}/${name}";
  filenameToContents = builtins.mapAttrs getFileContents dirListing;

  filenameToContentsAsList = lib.attrsets.attrsToList filenameToContents;
  swapNameAndValue =
    { name, value }:
    {
      name = value;
      value = name;
    };
  contentsToFilenameAsList = builtins.map swapNameAndValue filenameToContentsAsList;
  contentsToFilename = builtins.listToAttrs contentsToFilenameAsList;
in
contentsToFilename
