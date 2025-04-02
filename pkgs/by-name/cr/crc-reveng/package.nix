{
  stdenv,
  fetchzip,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "crc-reveng";
  version = "3.0.6";

  src = fetchzip {
    url = "mirror://sourceforge/reveng/${finalAttrs.version}/reveng-${finalAttrs.version}.tar.gz";
    hash = "sha256-+MysvtpynJ8cPzAL75TlrSvUfn34BsLBjLnZt9nXIbE=";
  };

  patches = [
    ./no_exe_extension_for_unix.patch
    ./do_not_hardcode_gcc_in_makefile.patch
  ] ++ (if stdenv.hostPlatform.is64bit then [ ./configure_for_64_bit_system.patch ] else [ ]);

  installPhase = ''
    install -D reveng -t $out/bin
  '';

  meta = {
    description = "Arbitrary-precision CRC calculator and algorithm finder";
    longDescription = ''
      CRC RevEng is a portable, arbitrary-precision CRC calculator and algorithm finder.
      It calculates CRCs using any of the 113 preset algorithms, or a user-specified algorithm to any width.
      It calculates reversed CRCs to give the bit pattern that produces a desired forward CRC.
      CRC RevEng also reverse-engineers any CRC algorithm from sufficient correctly formatted message-CRC pairs and optional known parameters.
      It comprises powerful input interpretation options. Compliant with Ross Williams' Rocksoft(tm) model of parametrised CRC algorithms.
    '';
    homepage = "https://reveng.sourceforge.io/";
    license = lib.licenses.gpl3Plus;
    changelog = "https://reveng.sourceforge.io/changes.htm";
    maintainers = with lib.maintainers; [
      acuteaangle
    ];
    mainProgram = "reveng";
  };
})
