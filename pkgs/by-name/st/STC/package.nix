{
  lib,
  stdenv,
  fetchFromGitHub,
  writeText,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stc";
  version = "4.2";

  src = fetchFromGitHub {
    owner = "stclib";
    repo = "STC";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vbFv1jPVeMQC58fVjoNlbB5w3EM/v4NGKqx0XvaJuns=";
  };

  dontBuild = true;

  dontFixup = true;

  outputs = [
    "out"
    "dev"
  ];

  installPhase =
    let
      pc = {
        name = "stc.pc";
        file = writeText name ''
          includedir=@PREFIX@/include

          Name: stc
          Description: Smart Template Containers
          URL: https://github.com/stclib/STC
          Version: ${finalAttrs.version}
          Cflags: -I''${includedir}
        '';
      };
    in
    ''
      runHook preInstall

      mkdir -p $out
      mkdir -p $dev/lib/pkgconfig

      cp -rf $src/include $out

      cp ${pc.file} $dev/lib/pkgconfig/${pc.name}

      substituteInPlace $dev/lib/pkgconfig/${pc.name} \
          --replace-fail '@PREFIX@' $out

      runHook postInstall
    '';

  meta = {
    description = "Smart Template Containers";
    longDescription = ''
      A modern, user friendly, generic, type-safe and fast C99 container library:
      String, Vector, Sorted and Unordered Map and Set, Deque, Forward List, Smart Pointers, Bitset and Random numbers.
    '';
    homepage = "https://github.com/stclib/STC";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ steve-chavez ];
    platforms = lib.platforms.unix;
  };
})
