{ lib
, stdenv
, fetchurl
, perl
, perlPackages
, makeWrapper
, which
, gzip
, curl
, gnutar
, zlib
}:

stdenv.mkDerivation rec {
  pname = "edirect";
  version = "1.0.0";

  src = fetchurl {
    url = "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/edirect.tar.gz";
    sha256 = "0kxli2m1zn5s64qzw6446p451pf12rb2nlrf3m1v9ghppcszcily";
  };


  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    perl
    perlPackages.HTMLParser
    perlPackages.LWP
    perlPackages.JSON
    perlPackages.XMLSimple
    curl
    gzip
    gnutar
    which
    zlib
  ];

  passthru = {
    getBinary = name: platform: fetchurl {
      url = "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/${name}.${platform}.gz";
      sha256 =
        # Linux binary hash
        if name == "xtract" && platform == "Linux" then "1qz6xh2alji55xyh1wxj2hc22jh4gr30c1qjfa1aancqj03qfjfd"
        else if name == "rchive" && platform == "Linux" then "0rmgjzgxhrzl0by015fibnaw5fjd20l3fh05xkmzfvyzvf5f01b2"
        else if name == "transmute" && platform == "Linux" then "0s3vahkkvam71r7n2xfjrl0l59xpzxkkwqcs5ncm6bwd7lib6yml"
        # Darwin(Intel Mac) binary hash
        else if name == "xtract" && platform == "Darwin" then "0lin12n5y3jrfqbz5csgc01hvbj1lsprcqxh1q8vczy81c3xn2ca"
        else if name == "rchive" && platform == "Darwin" then "08azjsx76ldcn9v905vr46xw6j7vx6bzwfk5a110h2rm3sk3c3ic"
        else if name == "transmute" && platform == "Darwin" then "19phqddr9qm271zgxv2l1z8ifdalkp7d7hfxcmrzchqfz8d1j8a5"
        # Silicon(Apple Silicon) binary hash 
        else if name == "xtract" && platform == "Silicon" then "1ml1cxgg0d7bn8xjy723zdsimf56vmd9g0a03fshjg2s0dabgsqg"
        else if name == "rchive" && platform == "Silicon" then "0iir3hnzyz49hbqh336m8xrsy7p0r83l4cbwbyn5w0r55pis124i"
        else if name == "transmute" && platform == "Silicon" then "1m3wfrp1q9s9xfxy872sa1xzhz6l8q6n3z3wai3cm0x5c6hlm30l"
        # ARM Linux binary hash
        else if name == "xtract" && platform == "ARM" then "17i7qdra5zmgqvhj0pyw1bb1sx9af0a16qcaa36glanihyq5pvyz"
        else if name == "rchive" && platform == "ARM" then "0l0nfxb5787b59scnlqaiqwzxqgxfbaabl9wzx9r0vm81av46w2l"
        else if name == "transmute" && platform == "ARM" then "0nalvzaj7fwqqjzyllpxqqv1zvj6znbsgm98sqrm6ackanbs7km2"
        # ARM64 Linux binary hash
        else if name == "xtract" && platform == "ARM64" then "0q193h6w193qrbbqscvshs66diykg71s4mpfn8xv88z0c3jicf2j"
        else if name == "rchive" && platform == "ARM64" then "08bpgyg925w1gdgf665qi6xi76gwr98zpq1wpg6mn6alyhsxzvar"
        else if name == "transmute" && platform == "ARM64" then "0xqs1w6k0rqfrxl5fj0yxdnyrlfgryijvvnjiq0np8rc22y0cir3"
        else throw "Unsupported System";
    };
  };

  # Determine current platform to install
  mainPlatform =
    if stdenv.isDarwin then
      if stdenv.isAarch64 then "Silicon" else "Darwin"
    else if stdenv.isLinux then
      if stdenv.isx86_64 then "Linux"
      else if stdenv.isAarch64 then "ARM64"
      else if stdenv.isAarch32 then "ARM"
      else "Linux"
    else if stdenv.isCygwin then "CYGWIN_NT"
    else "Linux";

  # for macOS, alternative platform settings required
  altPlatform =
    if stdenv.isDarwin then
      if stdenv.isAarch64 then "Darwin" else "Silicon"
    else "";

  unpackPhase = ''
    tar xzf $src
    cd edirect
  '';

  buildPhase = ''
    # xtract
    gunzip -c ${passthru.getBinary "xtract" mainPlatform} > xtract.$mainPlatform
    chmod +x xtract.$mainPlatform
    
    # rchive
    gunzip -c ${passthru.getBinary "rchive" mainPlatform} > rchive.$mainPlatform
    chmod +x rchive.$mainPlatform
    
    # transmute
    gunzip -c ${passthru.getBinary "transmute" mainPlatform} > transmute.$mainPlatform
    chmod +x transmute.$mainPlatform
    
    # Alternative binaries for macOS 
    ${lib.optionalString (altPlatform != "") ''
      gunzip -c ${passthru.getBinary "xtract" altPlatform} > xtract.$altPlatform
      chmod +x xtract.$altPlatform
      
      gunzip -c ${passthru.getBinary "rchive" altPlatform} > rchive.$altPlatform
      chmod +x rchive.$altPlatform
      
      gunzip -c ${passthru.getBinary "transmute" altPlatform} > transmute.$altPlatform
      chmod +x transmute.$altPlatform
    ''}
  '';

  installPhase = ''
        mkdir -p $out/bin $out/edirect

        cp -r * $out/edirect/
    
        for tool in xtract rchive transmute; do
          cat > $out/bin/$tool <<EOF
    #!/bin/sh
    exec $out/edirect/$tool.$mainPlatform "\$@"
    EOF
          chmod +x $out/bin/$tool
        done

        for file in eaddress eblast econtact edirect efetch egquery einfo elink epost esearch espell etimelines esummary; do
          if [ -f $file ]; then
            makeWrapper $out/edirect/$file $out/bin/$file \
              --prefix PATH : "${lib.makeBinPath [ perl curl which ]}" \
              --prefix PERL5LIB : "$out/edirect" \
              --set EDIRECT_PUBMED_MASTER "1" \
              --set EDIRECT_TOOLSET_MASTER "1"
          fi
        done
  '';

  meta = with lib; {
    description = "NCBI Entrez Direct (EDirect) Utility for accessing the NCBI's set of databases";
    homepage = "https://www.ncbi.nlm.nih.gov/books/NBK179288/";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ mulatta ];
    platforms = platforms.all;
  };
}
