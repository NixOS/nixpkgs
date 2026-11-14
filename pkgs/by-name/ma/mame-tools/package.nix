{ lib, mame, ... }@args:
lib.addMetaAttrs {
  description = mame.meta.description + " (tools only)";
} (lib.getOutput "tools" (mame.override (removeAttrs args [ "mame" ])))
