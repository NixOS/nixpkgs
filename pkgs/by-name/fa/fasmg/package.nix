{
  lib,
  stdenv,
  fetchzip,

  # update script
  writeScript,
  coreutils,
  curl,
  gnugrep,
  htmlq,
  nix-update,
}:

stdenv.mkDerivation rec {
  pname = "fasmg";
  version = "ktge";

  src = fetchzip {
    url = "https://flatassembler.net/fasmg.${version}.zip";
    sha256 = "sha256-z/2SeN6FgRvLg8hA+lle/f2qEkce1GF1cC0uSnXExhg=";
    stripRoot = false;
  };

  buildPhase =
    let
      inherit (stdenv.hostPlatform) system;

      path =
        {
          x86_64-linux = {
            bin = "fasmg.x64";
            asm = "source/linux/x64/fasmg.asm";
          };
          x86_64-darwin = {
            bin = "source/macos/x64/fasmg";
            asm = "source/macos/x64/fasmg.asm";
          };
          x86-linux = {
            bin = "fasmg";
            asm = "source/linux/fasmg.asm";
          };
          x86-darwin = {
            bin = "source/macos/fasmg";
            asm = "source/macos/fasmg.asm";
          };
        }
        .${system} or (throw "Unsupported system: ${system}");

    in
    ''
      chmod +x ${path.bin}
      ./${path.bin} ${path.asm} fasmg
    '';

  outputs = [
    "out"
    "doc"
  ];

  installPhase = ''
    install -Dm755 fasmg $out/bin/fasmg

    mkdir -p $doc/share/doc/fasmg
    cp docs/*.txt $doc/share/doc/fasmg
  '';

  passthru.updateScript = writeScript "update-fasmg.sh" ''
    export PATH="${
      lib.makeBinPath [
        coreutils
        curl
        gnugrep
        htmlq
        nix-update
      ]
    }:$PATH"
    version=$(
      curl 'https://flatassembler.net/download.php' \
        | htmlq .links a.boldlink  -a href \
        | grep -E '^fasmg\..*\.zip$' \
        | head -n1 \
        | cut -d. -f2
    )
    nix-update fasmg --version "$version"
  '';

  meta = with lib; {
    description = "x86(-64) macro assembler to binary, MZ, PE, COFF, and ELF";
    mainProgram = "fasmg";
    homepage = "https://flatassembler.net";
    license = licenses.bsd3;
    maintainers = [ ];
    platforms = with platforms; intersectLists (linux ++ darwin) x86;
  };
}
