{
  lib,
  fetchurl,
  makeWrapper,
  perl,
  perlPackages,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "imapsync";
  version = "2.290";

  src = fetchurl {
    url = "https://imapsync.lamiral.info/dist/old_releases/${finalAttrs.version}/imapsync-${finalAttrs.version}.tgz";
    hash = "sha256-uFhTxnaUDP793isfpF/7T8d4AnXDL4uN6zU8igY+EFE=";
  };

  postPatch = ''
    sed -i -e s@/usr@$out@ Makefile
    substituteInPlace INSTALL.d/prerequisites_imapsync --replace "PAR::Packer" ""
  '';

  postInstall = ''
    wrapProgram $out/bin/imapsync --set PERL5LIB $PERL5LIB
  '';

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = with perlPackages; [
    Appcpanminus
    CGI
    CryptOpenSSLRSA
    DataUniqid
    DistCheckConflicts
    EncodeIMAPUTF7
    FileCopyRecursive
    FileTail
    IOSocketINET6
    IOTee
    JSONWebToken
    LWP
    MailIMAPClient
    ModuleImplementation
    ModuleScanDeps
    NetServer
    NTLM
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

  meta = with lib; {
    description = "Mail folder synchronizer between IMAP servers";
    mainProgram = "imapsync";
    homepage = "https://imapsync.lamiral.info/";
    license = licenses.nlpl;
    maintainers = with maintainers; [
      pSub
      motiejus
    ];
    platforms = platforms.unix;
  };
})
