/* Get interpreter table field value.

Input:  Python attrset,
Output:  (str) interpreter textual representation.
*/
{ python }:
 let
  inherit (python) pythonVersion;

  implementationCasing = {
    cpython = "CPython";
    pypy = "PyPy";
  };

  formattedImplementation =
    implementationCasing.${python.implementation};

in ''${formattedImplementation} ${pythonVersion}''
