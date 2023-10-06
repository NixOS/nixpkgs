{ lib, ... }: {
  options = {
    # unlikely mistake, but we can catch any attrset with _type
    result = lib.evalModules { modules = []; };
  };
}
