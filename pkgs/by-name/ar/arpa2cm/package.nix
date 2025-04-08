{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "arpa2cm";
  version = "1.0.4";

  src = fetchFromGitLab {
    owner = "arpa2";
    repo = "arpa2cm";
    rev = "v${version}";
    hash = "sha256-2vb/7UL+uWGrQNh8yOZ3gih5G1/eOp064hF78SDsPGk=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "CMake Module library for the ARPA2 project";
    longDescription = ''
      The CMake module library for the ARPA2 project, including the LillyDAP,
      TLSPool and IdentityHub software stacks. Like the KDE Extra CMake Modules (ECM)
      which is a large-ish collection of curated CMake modules of particular
      interest to Qt-based and KDE Frameworks-based applications, the ARPA2
      CMake Modules (ARPA2CM) is a collection of modules for the software
      stack from the ARPA2 project. This is largely oriented towards
      TLS, SSL, X509, DER and LDAP technologies. The ARPA2 CMake Modules
      also include modules used for product release and deployment of
      the ARPA2 software stack.
    '';
    homepage = "https://gitlab.com/arpa2/arpa2cm";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      leenaars
      fufexan
    ];
  };
}
