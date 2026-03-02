{
  lib,
  fetchurl,
  makeWrapper,
  perl,
  perlPackages,
  stdenv,
  procps,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "imapsync";
  version = "2.314";

  src = fetchurl {
    url = "https://imapsync.lamiral.info/dist/old_releases/${finalAttrs.version}/imapsync-${finalAttrs.version}.tgz";
    hash = "sha256-NOFxXGWEiJ/zvZwKzC+rJURGKCvtqQyOWnGoOzpZ28o=";
  };

  postPatch = ''
    sed -i -e s@/usr@$out@ Makefile
    substituteInPlace INSTALL.d/prerequisites_imapsync --replace-fail "PAR::Packer" ""
  '';

  postInstall = ''
    wrapProgram $out/bin/imapsync \
      --set PERL5LIB $PERL5LIB \
      --prefix PATH : ${lib.makeBinPath [ procps ]}
  '';

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = with perlPackages; [
    Appcpanminus
    CGI
    CryptOpenSSLRSA
    DataUniqid
    DistCheckConflicts
    EmailAddress
    EncodeIMAPUTF7
    FileCopyRecursive
    FileTail
    HTTPDaemon
    HTTPDaemonSSL
    IOSocketINET6
    IOTee
    JSONWebToken
    LWP
    MailIMAPClient
    ModuleImplementation
    ModuleScanDeps
    NTLM
    NetDNS
    NetServer
    PackageStash
    PackageStashXS
    ProcProcessTable
    Readonly
    RegexpCommon
    SysMemInfo
    TermReadKey
    TestDeep
    TestFatal
    TestMockGuard
    TestMockObject
    TestPod
    TestRequires
    UnicodeString
    perl
  ];

  meta = {
    description = "Mail folder synchronizer between IMAP servers";
    homepage = "https://imapsync.lamiral.info";
    license = lib.licenses.nlpl;
    maintainers = with lib.maintainers; [
      pSub
      motiejus
    ];
    platforms = lib.platforms.unix;
    mainProgram = "imapsync";
  };
})
