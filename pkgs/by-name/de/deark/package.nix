{
  fetchFromGitHub,
  stdenv,
  lib,
  help2man,
  installShellFiles,
}:
stdenv.mkDerivation rec {
  pname = "deark";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "jsummers";
    repo = "deark";
    tag = "v${version}";
    hash = "sha256-EnolN4uSHDm1sIkbwCmZUe70DdHyXP3Si4QwGaMtN0A=";
  };

  nativeBuildInputs = [
    help2man
    installShellFiles
  ];
  postBuild = ''
    make man
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 deark $out/bin/deark
    installManPage deark.1

    runHook postInstall
  '';

  meta = {
    description = "Utility for file format and metadata analysis, data extraction, decompression, and image format decoding";
    longDescription = ''
      Deark is a portable command-line utility that can decode certain
      types of files, and either convert them to a more-modern or
      more-readable format, or extract embedded files from them.
    '';
    homepage = "https://entropymine.com/deark/";
    downloadPage = "https://github.com/jsummers/deark/";
    # cf. READMEs under "foreign" folder for details
    license = with lib.licenses; [
      mit
      # deark itself + modifications to foreign code, sans foreign code
      # ozunreduce.h (dual-licensed: MIT is one option)
      free
      # miniz*.h (MIT-style, predates standardized licenses)
      # ozunreduce.h (dual-licensed: public domain is one option)
      # dskdcmps.h (public domain)
      # uncompface.h ("Permission is given to distribute these sources, as long as the
      #                copyright messages are not removed, and no monies are exchanged"
      #                + waiver of liability)
      unfreeRedistributable
      # lzhuf.* (no copywrite notice, predates standardized licenses,
      #          widely distributed & intent appears to be free use)
      # "By necessity, Deark contains knowledge about how to decode various
      # third-party file formats. This knowledge includes data structures,
      # algorithms, tables, color palettes, etc. The author(s) of Deark
      # make no intellectual property claims to this essential knowledge,
      # but they cannot guarantee that no one else will attempt to do so.
      # Deark contains VGA and CGA bitmapped fonts, which have no known
      # copyright claims."
    ];
    maintainers = with lib.maintainers; [ zacharyweiss ];
    mainProgram = "deark";
    platforms = lib.platforms.unix;
  };
}
