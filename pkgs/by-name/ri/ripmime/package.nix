{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "ripmime";
  version = "1.4.0.10";
  src = fetchurl {
    url = "https://pldaniels.com/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0sj06ibmlzy34n8v0mnlq2gwidy7n2aqcwgjh0xssz3vi941aqc9";
  };

  preInstall = ''
    sed -i Makefile -e "s@LOCATION=.*@LOCATION=$out@" -e "s@man/man1@share/&@"
    mkdir -p "$out/bin" "$out/share/man/man1"
  '';

  env = {
    NIX_CFLAGS_COMPILE = " -Wno-error ";
  }
  // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_LDFLAGS = "-liconv";
  };

  meta = with lib; {
    description = "Attachment extractor for MIME messages";
    maintainers = with maintainers; [ raskin ];
    homepage = "https://pldaniels.com/ripmime/";
    platforms = platforms.all;
    mainProgram = "ripmime";
  };

  passthru = {
    updateInfo = {
      downloadPage = "https://pldaniels.com/ripmime/";
    };
  };
}
