{
  lib,
  stdenvNoCC,
  john,
  python3Packages,
  perl,
  perlPackages,
  makeWrapper,
}:

let
  # Perl modules the .pl helpers need at runtime. Kept in a binding so the same
  # list feeds both propagatedBuildInputs and the PERL5LIB the wrappers bake in.
  # The latter is built explicitly with makeFullPerlPath because strictDeps keeps
  # propagated host deps out of the build-time $PERL5LIB.
  perlModules = with perlPackages; [
    # For pass_gen.pl and netntlm.pl
    DigestMD4
    GetoptLong
    # For 7z2john.pl
    CompressRawLzma
    # For sha-dump.pl
    perlldap
  ];
in
# The interpreted *2john conversion scripts shipped with John the Ripper, split
# out of the core `john` package (which only carries the binary and the compiled
# C helpers). This mirrors the john / john-data split done by Debian and Kali and
# keeps the large python/perl runtime closure these scripts need out of `john`.
stdenvNoCC.mkDerivation {
  pname = "john-data";
  inherit (john) version src;

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    python3Packages.wrapPython
    perl
    makeWrapper
  ];

  propagatedBuildInputs =
    (with python3Packages; [
      # For pcap2john.py and radius2john.py
      dpkt
      scapy
      # For krb2john.py
      lxml
      # For pdf2john.py
      pyhanko
      # For pem2john.py and pfx2john.py
      asn1crypto
      # For fvde2john.py (also needs pytsk3, not packaged in nixpkgs)
      cryptography
      # For DPAPImk2john.py, keplr2john.py, telegram2john.py, zed2john.py
      pycryptodome
      # For ccache2john.py, kirbi2john.py
      pyasn1
      # For coinomi2john.py and multibit2john.py — they import generated
      # `protobuf.coinomi_pb2` / `protobuf.wallet_pb2` modules from the bundled
      # run/protobuf/ tree installed below; the runtime needs google.protobuf
      # (provided by python3Packages.protobuf).
      protobuf
      # For cardano2john.py
      cbor2
      # For ejabberd2john.py
      parsimonious
      # For 1password2john.py, bitwarden2john.py, ethereum2john.py,
      # padlock2john.py and electrum2john.py
      simplejson
      # For sspr2john.py
      ldap3
      # For office2john.py — upstream PR #5931 dropped the bundled olefile copy,
      # so it is now an external dependency.
      olefile
      # For pcap2john.py (the DNS/TACACS+ code path)
      dnspython
      # For bitwarden2john.py
      plyvel
      # For keplr2john.py (it reads Chrome LevelDB via the bundled
      # ccl_chrome_indexeddb tree installed below)
      scrypt
    ])
    ++ perlModules;
  # Not packaged in nixpkgs, so the corresponding scripts cannot run:
  #   bitcoin2john.py -> bsddb3
  #   fvde2john.py    -> pytsk3
  #   pse2john.py     -> pysap
  #   itunes_backup2john.pl, lion2john-alt.pl -> Data::Plist
  #   sha-test.pl     -> SHA (legacy module; a dev test script, not a converter)
  # defusedexpat (signal2john.py, sspr2john.py) is also unpackaged, but those
  # scripts fall back to the stdlib expat, so they still work.

  dontConfigure = true;
  dontBuild = true;

  postPatch = ''
    # Rewrite the bundled john.conf .include paths to absolute store paths so
    # rulestack.pl (via jtrconf.pm) can resolve them.
    sed -ri -e '/^\.include/ {
      s!\$JOHN!'"$out"'/etc/john!
      s!^(\.include\s*)<([^./]+\.conf)>!\1"'"$out"'/etc/john/\2"!
    }' run/*.conf
    # atmail2john.pl: portable shebang.
    substituteInPlace run/atmail2john.pl \
      --replace-fail '#!/usr/bin/perl' '#!/usr/bin/env perl'
    # leet.pl: pin perl directly so the `-l` flag survives patchShebangs
    # (env can't pass multi-word args reliably).
    substituteInPlace run/leet.pl \
      --replace-fail '#! /usr/bin/perl -l' '#!${perl}/bin/perl -l'
    # jtrconf.pm looks for john.conf next to itself; point it at $out/etc/john.
    # Also stop it from prepending './' to .include paths we've rewritten to
    # absolute store paths.
    substituteInPlace run/jtrconf.pm \
      --replace-fail "dirname(__FILE__).'/'" "'$out/etc/john/'" \
      --replace-fail "\$dirname = './';" "\$dirname = substr(\$inc_name, 0, 1) eq '/' ? ''' : './';"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/etc/john" "$out/share/john/rules" "$out/${perlPackages.perl.libPrefix}"

    # The interpreted *2john conversion scripts. pkcs12kdf.py has no shebang and
    # is imported by zed2john.py; it is copied as a plain module (not wrapped).
    # aix2john.pl, pdf2john.pl and radius2john.pl are skipped — they are
    # superseded by the equivalent aix2john.py / pdf2john.py / radius2john.py.
    find -L run -mindepth 1 -maxdepth 1 -type f -executable \
      \( -name '*.py' -o -name '*.pl' \) \
      ! -name 'aix2john.pl' ! -name 'pdf2john.pl' ! -name 'radius2john.pl' \
      -exec cp -d {} "$out/bin" \;

    # config + rules so rulestack.pl can resolve john.conf's rule includes.
    cp -t "$out/etc/john" run/*.conf
    cp -t "$out/share/john/rules" run/rules/*.rule
    # john.conf has `.include <rules/foo.rule>` resolved against $out/etc/john;
    # the actual rule files live under share/john.
    ln -s "$out/share/john/rules" "$out/etc/john/rules"

    # Perl helper modules used by the .pl scripts (ExifTool.pm, PDF.pm, … and
    # jtrconf.pm).
    cp -t "$out/${perlPackages.perl.libPrefix}" run/lib/* run/jtrconf.pm

    # Bundled support trees the scripts import/read relative to their own
    # location (sys.argv[0] / sys.path). The wrapped scripts live in $out/bin,
    # so these must sit alongside them:
    #   protobuf/            -> coinomi2john.py, multibit2john.py (from protobuf.*_pb2)
    #   ccl_chrome_indexeddb/ -> keplr2john.py (from ccl_chrome_indexeddb import …)
    #   bip-0039/            -> tezos2john.py (BIP-39 wordlist data dir)
    cp -r run/protobuf run/ccl_chrome_indexeddb run/bip-0039 "$out/bin/"

    runHook postInstall
  '';

  postFixup = ''
    wrapPythonPrograms

    for i in "$out"/bin/*.pl; do
      wrapProgram "$i" \
        --prefix PATH : "${lib.makeBinPath [ perl ]}" \
        --prefix PERL5LIB : "${perlPackages.makeFullPerlPath perlModules}:$out/${perlPackages.perl.libPrefix}"
    done

    # The bundled protobuf/*_pb2.py modules were generated against an older
    # protoc; force the pure-Python implementation so they load against the
    # current python3Packages.protobuf.
    for i in "$out"/bin/coinomi2john.py "$out"/bin/multibit2john.py; do
      wrapProgram "$i" --set PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION python
    done
  '';

  meta = {
    description = "Conversion scripts and data files for John the Ripper";
    longDescription = ''
      The architecture-independent *2john conversion scripts that ship with John
      the Ripper (jumbo), packaged separately from the core `john` package. These
      Python and Perl helpers extract crackable hashes from a wide range of file
      formats and applications (PDF, SSH keys, office documents, wallets, …) for
      use with `john`. Split out so the core `john` package does not pull in the
      large python/perl runtime closure they depend on.
    '';
    homepage = "https://github.com/openwall/john/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      mag1cbyt3s
      cherrykitten
      therealhammer
    ];
    platforms = lib.platforms.unix;
  };
}
