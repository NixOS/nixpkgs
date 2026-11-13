{
  runCommand,
  cosmopolitan,
  unzip,
  fetchurl,
}:

let
  version = "3.9.2";
  cosmocc-zip = fetchurl {
    url = "https://github.com/jart/cosmopolitan/releases/download/${version}/cosmocc-${version}.zip";
    sha256 = "sha256-9P8Tr2X80wnz8c/QQnWZb7f3KkiXcmYoqMnPcy6FAZM=";
  };

  cosmocc =
    runCommand "cosmocc-${cosmopolitan.version}"
      {
        pname = "cosmocc";
        inherit (cosmopolitan) version;

        nativeBuildInputs = [ unzip ];

        passthru.tests = {
          cc = runCommand "c-test" { nativeBuildInputs = [ unzip ]; } ''
            ${cosmocc}/bin/cosmocc ${./hello.c}
            ./a.out > $out
          '';
        };

        meta = cosmopolitan.meta // {
          description = "Compilers for Cosmopolitan C/C++ programs";
        };
      }
      ''
        mkdir -p $out
        unzip -qo ${cosmocc-zip} -d $out
      '';
in
cosmocc
