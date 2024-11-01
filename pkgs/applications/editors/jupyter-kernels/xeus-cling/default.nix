{ callPackage
, cling
, fetchurl
, stdenv
}:

# Jupyter console:
# nix run --impure --expr 'with import <nixpkgs> {}; jupyter-console.withSingleKernel cpp17-kernel'

# Jupyter notebook:
# nix run --impure --expr 'with import <nixpkgs> {}; jupyter.override { definitions = { cpp17 = cpp17-kernel; }; }'

let
  xeus-cling = callPackage ./xeus-cling.nix {};

  mkDefinition = std:
    let
      versionSuffix =
        if std == "c++11" then " 11"
        else if std == "c++14" then " 14"
        else if std == "c++17" then " 17"
        else if std == "c++17" then " 17"
        else if std == "c++2a" then " 2a"
        else throw "Unexpected C++ std for cling: ${std}";
    in
      {
        displayName = "C++" + versionSuffix;
        argv = [
          "${xeus-cling}/bin/xcpp"
        ]
        ++ cling.flags
        ++ [
          "-resource-dir" "${cling.unwrapped}"
          "-L" "${cling.unwrapped}/lib"
          "-l" "${cling.unwrapped}/lib/cling.so"
          "-std=${std}"
          # "-v"
          "-f" "{connection_file}"
        ];
        language = "cpp";
        logo32 = fetchurl {
          url = "https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/ISO_C%2B%2B_Logo.svg/32px-ISO_C%2B%2B_Logo.svg.png";
          hash = "sha256-cr0TB8/j2mkcFhfCkz9F7ZANOuTlWA2OcWtDcXyOjHw=";
        };
        logo64 = fetchurl {
          url = "https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/ISO_C%2B%2B_Logo.svg/64px-ISO_C%2B%2B_Logo.svg.png";
          hash = "sha256-nZtJ4bR7GmQttvqEJC9KejOxphrjjxT36L9yOIITFLk=";
        };
      };

in

{
  cpp11-kernel = mkDefinition "c++11";
  cpp14-kernel = mkDefinition "c++14";
  cpp17-kernel = mkDefinition "c++17";
  cpp2a-kernel = mkDefinition "c++2a";
}
