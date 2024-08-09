{ lib, stdenv, fetchFromGitHub, writeText }:

stdenv.mkDerivation rec {
  pname = "STC";
  version = "v4.2";

  src = fetchFromGitHub {
    owner = "stclib";
    repo = pname;
    rev = version;
    hash = "sha256-vbFv1jPVeMQC58fVjoNlbB5w3EM/v4NGKqx0XvaJuns=";
  };

  phases = [ "unpackPhase" "installPhase" ];

  outputs = [ "out" "dev"];

  installPhase =
    let
      pc = rec {
        name = "${pname}.pc";
        file = writeText name ''
          includedir=@PREFIX@/include

          Name: ${pname}
          Description: Smart Template Containers
          Version: ${version}
          Cflags: -I''${includedir}
        '';
      };
    in
    ''
      mkdir -p $out
      mkdir -p $dev/lib/pkgconfig

      cp -rf $src/include $out

      cp ${pc.file} $dev/lib/pkgconfig/${pc.name}

      sed -i -e "s@\@PREFIX\@@$out@" $dev/lib/pkgconfig/${pc.name}
    '';

  meta = with lib; {
    description = "Smart Template Containers";
    longDescription = ''
      A modern, user friendly, generic, type-safe and fast C99 container library:
      String, Vector, Sorted and Unordered Map and Set, Deque, Forward List, Smart Pointers, Bitset and Random numbers.
    '';
    homepage = "https://github.com/stclib/STC";
    license = licenses.mit;
    maintainers = with maintainers; [ steve-chavez ];
    platforms = platforms.unix;
  };
}
