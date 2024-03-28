{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  libbsd,
}: let
  inherit (stdenvNoCC.hostPlatform) system;
  selectSystem = attrs: attrs.${system} or (throw "Unsupported system: ${system}");
in
  stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "csh";
    version = "20230828";

    src = fetchurl {
      url = selectSystem {
        "aarch64-linux" = "http://deb.debian.org/debian/pool/main/c/csh/csh_${finalAttrs.version}-1_arm64.deb";
        "x86_64-linux" = "http://deb.debian.org/debian/pool/main/c/csh/csh_${finalAttrs.version}-1_amd64.deb";
      };
      hash = selectSystem {
        "aarch64-linux" = "sha256-Dax671mBzu+vNOSy6qXkMz3vpBA/fDrgEDZEZ35WkD0=";
        "x86_64-linux" = "sha256-x5nxdSzjKZoIMyj0ObxKpvmvaqszsMoYRfHShcc3znM=";
      };
    };

    unpackPhase = ''
      runHook preUnpack
      ar x $src
      tar xf data.tar.xz
      rm control.tar.xz data.tar.xz debian-binary
      runHook postUnpack
    '';

    nativeBuildInputs = [
      libbsd
      autoPatchelfHook
    ];

    installPhase = ''
      mkdir -p "$out"/bin/
      cp bin/bsd-csh $out/bin/csh
    '';

    meta = with lib; {
      description = "Shell with C-like syntax";
      longDescription = ''
        The C shell was originally written at UCB to overcome limitations in the
        Bourne shell. Its flexibility and comfort (at that time) quickly made it
        the shell of choice until more advanced shells like ksh, bash, zsh or tcsh
        appeared. Most of the latter incorporate features original to csh.

        This package is based on current OpenBSD sources (as mirrored through
        debian).
      '';
      license = licenses.bsd3;
      maintainers = [maintainers.cafkafk];
      mainProgram = "csh";
      platforms = ["aarch64-linux" "x86_64-linux"];
    };

    passthru = {
      shellPath = "/bin/csh";
    };
  })
