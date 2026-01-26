{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  perl,
  perlPackages,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dnswalk";
  version = "2.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/dnswalk/dnswalk-${finalAttrs.version}.tar.gz";
    sha512 = "23e5408149ae65f69dbb6d0ecaf5b10233e2279a502f6e19f0dacde0e270ed4eed0aea72f8c12dd636228e99b0b115a335bb8327a0628ad1f36dae5f5572712c";
  };

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/BlackArch/blackarch/cb22ac52795e2a1e10ec9a51fb1d16ebfa3854e1/packages/dnswalk/dnswalk.patch";
      name = "dnswalk.patch";
      hash = "sha256-JnxKKRO1t5uTwNva0zdDkxwGTHdTqU4K9ZeAgCdyjEc=";
    })
    (fetchpatch {
      url = "https://github.com/davebarr/dnswalk/commit/83625aeb4adbb844ce0832329896040663b55e6b.patch";
      name = "0001-SOA-use-query-instead-of-packet.patch";
      hash = "sha256-kyCoH9ghSS2WFb5haH3l1WX1DAWAFJlGVwsY9LNWb2c=";
    })
  ];
  nativeBuildInputs = [ makeWrapper ];

  # unpacker appears to have produced no directories
  unpackPhase = ''
    mkdir -p $PWD/src
    tar xzf $src -C $PWD/src
    cd $PWD/src
  '';

  postPatch = ''
    sed -i 's|/usr/contrib/bin/perl|${lib.getExe perl}|' dnswalk
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 dnswalk $out/bin/dnswalk

    mkdir -p $out/share/doc/dnswalk
    install -m644 do-dnswalk CHANGES README TODO rfc1912.txt makereports sendreports $out/share/doc/dnswalk/
    install -Dm644 dnswalk.1 $out/share/man/man1/dnswalk.1
    install -m644 dnswalk.errors $out/share/doc/dnswalk/

    wrapProgram $out/bin/dnswalk \
      --set PERL5LIB "${perlPackages.NetDNS}/${perl.libPrefix}" \
      --set PERL5OPT "-M-warnings=deprecated"

    runHook postInstall
  '';

  meta = {
    description = "A DNS debugger and zone-transfer utility";
    homepage = "http://sourceforge.net/projects/dnswalk/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ makefu ];
  };
})
