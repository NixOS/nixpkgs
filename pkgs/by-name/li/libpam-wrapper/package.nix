{
  lib,
  stdenv,
  fetchgit,
  cmake,
  linux-pam,
  replaceVars,
  enablePython ? false,
  python ? null,
}:

assert enablePython -> python != null;

stdenv.mkDerivation rec {
  pname = "libpam-wrapper";
  version = "1.1.5";

  src = fetchgit {
    url = "git://git.samba.org/pam_wrapper.git";
    rev = "pam_wrapper-${version}";
    hash = "sha256-AtfkiCUvCxUfll6lOlbMyy5AhS5R2BGF1+ecC1VuwzM=";
  };

  patches = [
    (replaceVars ./python.patch {
      siteDir = lib.optionalString enablePython python.sitePackages;
      includeDir = lib.optionalString enablePython "include/${python.libPrefix}";
    })
  ];

  nativeBuildInputs = [ cmake ] ++ lib.optionals enablePython [ python ];

  # We must use linux-pam, using openpam will result in broken fprintd.
  buildInputs = [ linux-pam ];

  meta = with lib; {
    description = "Wrapper for testing PAM modules";
    homepage = "https://cwrap.org/pam_wrapper.html";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
