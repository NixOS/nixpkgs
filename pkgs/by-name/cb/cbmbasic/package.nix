{
  lib,
  stdenv,
  fetchFromGitHub,
  runCommand,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cbmbasic";
  version = "0-unstable-2022-12-18";

  src = fetchFromGitHub {
    owner = "mist64";
    repo = "cbmbasic";
    rev = "352a313313dd0a15a47288c8f8031b54ac8c92a2";
    hash = "sha256-aA/ivRap+aDd2wi6KWXam9eP/21lOn6OWTeZ4i/S9Bs=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin/
    mv cbmbasic $out/bin/

    runHook postInstall
  '';

  # NOTE: cbmbasic uses microsoft style linebreaks `\r\n`, and testing has to
  # accommodate that, else you get very cryptic diffs
  passthru = {
    tests.run =
      runCommand "cbmbasic-test-run"
        {
          nativeBuildInputs = [ finalAttrs.finalPackage ];
        }
        ''
          echo '#!${lib.getExe finalAttrs.finalPackage}' > helloI.bas;
          echo 'PRINT"Hello, World!"' >> helloI.bas;
          chmod +x helloI.bas

          diff -U3 --color=auto <(./helloI.bas) <(echo -e "Hello, World!\r");

          echo '#!/usr/bin/env cbmbasic' > hello.bas;
          echo 'PRINT"Hello, World!"' >> hello.bas;
          chmod +x hello.bas

          diff -U3 --color=auto <(cbmbasic ./hello.bas) <(echo -e "Hello, World!\r");

          touch $out;
        '';
  };

  meta = with lib; {
    description = "Portable version of Commodore's version of Microsoft BASIC 6502 as found on the Commodore 64";
    longDescription = ''
      "Commodore BASIC" (cbmbasic) is a 100% compatible version of Commodore's
      version of Microsoft BASIC 6502 as found on the Commodore 64. You can use
      it in interactive mode or pass a BASIC file as a command line parameter.

      This source does not emulate 6502 code; all code is completely native. On
      a 1 GHz CPU you get about 1000x speed compared to a 1 MHz 6502.
    '';
    homepage = "https://github.com/mist64/cbmbasic";
    license = licenses.bsd2;
    maintainers = [ maintainers.cafkafk ];
    mainProgram = "cbmbasic";
    platforms = platforms.all;
  };
})
