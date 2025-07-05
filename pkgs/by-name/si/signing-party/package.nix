{
  lib,
  stdenv,
  fetchFromGitLab,
  autoconf,
  automake,
  makeWrapper,
  python3,
  perl,
  perlPackages,
  libmd,
  gnupg,
  which,
  getopt,
  libpaper,
  nettools,
  qprint,
  sendmailPath ? "/run/wrappers/bin/sendmail",
}:

let
  # All runtime dependencies from the CPAN graph:
  # https://widgets.stratopan.com/wheel?q=GnuPG-Interface-0.52&runtime=1&fs=1
  GnuPGInterfaceRuntimeDependencies = with perlPackages; [
    strictures
    ClassMethodModifiers
    DataPerl
    DevelGlobalDestruction
    ExporterTiny
    GnuPGInterface
    ListMoreUtils
    ModuleRuntime
    Moo
    MooXHandlesVia
    MooXlate
    RoleTiny
    SubExporterProgressive
    SubQuote
    TypeTiny
  ];
in
stdenv.mkDerivation rec {
  pname = "signing-party";
  version = "2.12";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "signing-party-team";
    repo = "signing-party";
    rev = "v${version}";
    sha256 = "sha256-hUlMClx/TRmnC2Ah6MIsNGpZGI/KmgWt2z4XzbIAnag=";
  };

  # TODO: Get this patch upstream...
  patches = [ ./gpgwrap_makefile.patch ];

  postPatch = ''
    substituteInPlace gpg-mailkeys/gpg-mailkeys --replace \
      "/usr/sbin/sendmail" "${sendmailPath}"
  '';

  # One can use the following command to find all relevant Makefiles:
  # grep -R '$(DESTDIR)/usr' | cut -d: -f1 | sort -u | grep -v 'debian/rules'
  preBuild = ''
    substituteInPlace gpgsigs/Makefile --replace '$(DESTDIR)/usr' "$out"
    substituteInPlace keyanalyze/Makefile --replace '$(DESTDIR)/usr' "$out"
    substituteInPlace keylookup/Makefile --replace '$(DESTDIR)/usr' "$out"
    substituteInPlace sig2dot/Makefile --replace '$(DESTDIR)/usr' "$out"
    substituteInPlace springgraph/Makefile --replace '$(DESTDIR)/usr' "$out"
  '';

  # Perl is required for it's pod2man.
  # Python and Perl are required for patching the script interpreter paths.
  nativeBuildInputs = [
    autoconf
    automake
    makeWrapper
  ];
  buildInputs = [
    python3
    perl
    perlPackages.GnuPGInterface
    libmd
    gnupg
  ];

  postInstall = ''
    # Install all tools which aren't handled by 'make install'.
    # TODO: Fix upstream...!

    # caff: CA - Fire and Forget signs and mails a key
    install -D -m555 caff/caff $out/bin/caff;
    install -D -m444 caff/caff.1 $out/share/man/man1/caff.1;

    # pgp-clean: removes all non-self signatures from key
    install -D -m555 caff/pgp-clean $out/bin/pgp-clean;
    install -D -m444 caff/pgp-clean.1 $out/share/man/man1/pgp-clean.1;

    # pgp-fixkey: removes broken packets from keys
    install -D -m555 caff/pgp-fixkey $out/bin/pgp-fixkey;
    install -D -m444 caff/pgp-fixkey.1 $out/share/man/man1/pgp-fixkey.1;

    # gpg-mailkeys: simply mail out a signed key to its owner
    install -D -m555 gpg-mailkeys/gpg-mailkeys $out/bin/gpg-mailkeys;
    install -D -m444 gpg-mailkeys/gpg-mailkeys.1 $out/share/man/man1/gpg-mailkeys.1;

    # gpg-key2ps: generate PostScript file with fingerprint paper slips
    install -D -m555 gpg-key2ps/gpg-key2ps $out/bin/gpg-key2ps;
    install -D -m444 gpg-key2ps/gpg-key2ps.1 $out/share/man/man1/gpg-key2ps.1;

    # gpgdir: recursive directory encryption tool
    install -D -m555 gpgdir/gpgdir $out/bin/gpgdir;
    install -D -m444 gpgdir/gpgdir.1 $out/share/man/man1/gpgdir.1;

    # gpglist: show who signed which of your UIDs
    install -D -m555 gpglist/gpglist $out/bin/gpglist;
    install -D -m444 gpglist/gpglist.1 $out/share/man/man1/gpglist.1;

    # gpgsigs: annotates list of GnuPG keys with already done signatures
    # The manual page is not handled by 'make install'
    install -D -m444 gpgsigs/gpgsigs.1 $out/share/man/man1/gpgsigs.1;

    # gpgparticipants: create list of party participants for the organiser
    install -D -m555 gpgparticipants/gpgparticipants $out/bin/gpgparticipants;
    install -D -m444 gpgparticipants/gpgparticipants.1 $out/share/man/man1/gpgparticipants.1;
    install -D -m555 gpgparticipants/gpgparticipants-prefill $out/bin/gpgparticipants-prefill;
    install -D -m444 gpgparticipants/gpgparticipants-prefill.1 $out/share/man/man1/gpgparticipants-prefill.1;
    install -D -m555 gpgparticipants/gpgparticipants-filter $out/bin/gpgparticipants-filter;
    install -D -m444 gpgparticipants/gpgparticipants-filter.1 $out/share/man/man1/gpgparticipants-filter.1;

    # gpgwrap: a passphrase wrapper
    install -D -m555 gpgwrap/bin/gpgwrap $out/bin/gpgwrap;
    install -D -m444 gpgwrap/doc/gpgwrap.1 $out/share/man/man1/gpgwrap.1;

    # keyanalyze: minimum signing distance (MSD) analysis on keyrings
    # Only the binaries are handled by 'make install'
    install -D -m444 keyanalyze/keyanalyze.1 $out/share/man/man1/keyanalyze.1;
    install -D -m444 keyanalyze/pgpring/pgpring.1 $out/share/man/man1/pgpring.1;
    install -D -m444 keyanalyze/process_keys.1 $out/share/man/man1/process_keys.1;

    # keylookup: ncurses wrapper around gpg --search
    # Handled by 'make install'

    # sig2dot: converts a list of GnuPG signatures to a .dot file
    # Handled by 'make install'

    # springgraph: creates a graph from a .dot file
    # Handled by 'make install'

    # keyart: creates a random ASCII art of a PGP key file
    install -D -m555 keyart/keyart $out/bin/keyart;
    install -D -m444 keyart/doc/keyart.1 $out/share/man/man1/keyart.1;

    # gpg-key2latex: generate LaTeX file with fingerprint paper slips
    install -D -m555 gpg-key2latex/gpg-key2latex $out/bin/gpg-key2latex;
    install -D -m444 gpg-key2latex/gpg-key2latex.1 $out/share/man/man1/gpg-key2latex.1;
  '';

  postFixup = ''
        # Add the runtime dependencies for all programs (but mainly for the Perl
        # scripts)

        wrapProgram $out/bin/caff --set PERL5LIB \
          ${
            with perlPackages;
            makePerlPath (
              [
                TextTemplate
                MIMETools
                MailTools
                TimeDate
                NetIDNEncode
                SubHandlesVia
              ]
              ++ GnuPGInterfaceRuntimeDependencies
            )
          } \
          --prefix PATH ":" \
          "${
            lib.makeBinPath [
              nettools
              gnupg
            ]
          }"

        wrapProgram $out/bin/gpg-key2latex --set PERL5LIB \
          ${perlPackages.makePerlPath GnuPGInterfaceRuntimeDependencies} \
          --prefix PATH ":" \
          "${
            lib.makeBinPath [
              gnupg
              libpaper
            ]
          }"

        wrapProgram $out/bin/gpg-key2ps --prefix PATH ":" \
          "${
            lib.makeBinPath [
              which
              gnupg
              libpaper
            ]
          }"

        wrapProgram $out/bin/gpg-mailkeys --prefix PATH ":" \
          "${
            lib.makeBinPath [
              gnupg
              qprint
            ]
          }"

        wrapProgram $out/bin/gpgdir --set PERL5LIB \
          ${
            with perlPackages;
            makePerlPath (
              [
                TermReadKey
              ]
              ++ GnuPGInterfaceRuntimeDependencies
            )
          } \
          --prefix PATH ":" \
          "${lib.makeBinPath [ gnupg ]}"

        wrapProgram $out/bin/gpglist --prefix PATH ":" \
          "${lib.makeBinPath [ gnupg ]}"

        wrapProgram $out/bin/gpgparticipants --prefix PATH ":" \
          "${
            lib.makeBinPath [
              getopt
              gnupg
            ]
          }"

    #    wrapProgram $out/bin/gpgparticipants-prefill

        wrapProgram $out/bin/gpgparticipants-filter --prefix PATH ":" \
          "${lib.makeBinPath [ gnupg ]}"

        wrapProgram $out/bin/gpgsigs --set PERL5LIB \
          ${perlPackages.makePerlPath GnuPGInterfaceRuntimeDependencies} \
          --prefix PATH ":" \
          "${lib.makeBinPath [ gnupg ]}"

        wrapProgram $out/bin/gpgwrap --prefix PATH ":" \
          "${lib.makeBinPath [ gnupg ]}"

    #    wrapProgram $out/bin/keyanalyze --set PERL5LIB \

        wrapProgram $out/bin/keyart --prefix PATH ":" \
          "${lib.makeBinPath [ gnupg ]}"

        wrapProgram $out/bin/keylookup --prefix PATH ":" \
          "${lib.makeBinPath [ gnupg ]}"

        wrapProgram $out/bin/pgp-clean --set PERL5LIB \
          ${perlPackages.makePerlPath GnuPGInterfaceRuntimeDependencies} \
          --prefix PATH ":" \
          "${lib.makeBinPath [ gnupg ]}"

        wrapProgram $out/bin/pgp-fixkey --set PERL5LIB \
          ${perlPackages.makePerlPath GnuPGInterfaceRuntimeDependencies} \
          --prefix PATH ":" \
          "${lib.makeBinPath [ gnupg ]}"

    #    wrapProgram $out/bin/pgpring

    #    wrapProgram $out/bin/process_keys

         # Upstream-Bug: Seems like sig2dot doesn't work with 2.1 (modern) anymore,
         # please use 2.0 (stable) instead.
    #    wrapProgram $out/bin/sig2dot

        wrapProgram $out/bin/springgraph --set PERL5LIB \
          ${with perlPackages; makePerlPath [ GD ]}
  '';

  meta = with lib; {
    homepage = "https://salsa.debian.org/signing-party-team/signing-party";
    description = "Collection of several projects relating to OpenPGP";
    longDescription = ''
      This is a collection of several projects relating to OpenPGP.

      * caff: CA - Fire and Forget signs and mails a key
      * pgp-clean: removes all non-self signatures from key
      * pgp-fixkey: removes broken packets from keys
      * gpg-mailkeys: simply mail out a signed key to its owner
      * gpg-key2ps: generate PostScript file with fingerprint paper slips
      * gpgdir: recursive directory encryption tool
      * gpglist: show who signed which of your UIDs
      * gpgsigs: annotates list of GnuPG keys with already done signatures
      * gpgparticipants: create list of party participants for the organiser
      * gpgwrap: a passphrase wrapper
      * keyanalyze: minimum signing distance (MSD) analysis on keyrings
      * keylookup: ncurses wrapper around gpg --search
      * sig2dot: converts a list of GnuPG signatures to a .dot file
      * springgraph: creates a graph from a .dot file
      * keyart: creates a random ASCII art of a PGP key file
      * gpg-key2latex: generate LaTeX file with fingerprint paper slips
    '';
    license = with licenses; [
      bsd2
      bsd3
      gpl2Only
      gpl2Plus
      gpl3Plus
    ];
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
