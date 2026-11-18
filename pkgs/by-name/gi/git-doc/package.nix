{ gitFull, lib }:
if gitFull ? doc then
  lib.addMetaAttrs {
    description = "Additional documentation for Git";
    longDescription = ''
      This package contains additional documentation (HTML and text files) that
      are referenced in the man pages of Git.
    '';
  } gitFull.doc
else
  throw "'git-doc' can't be evaluated as 'gitFull doesn't expose a 'doc' attribute"
