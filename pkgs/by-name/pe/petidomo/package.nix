{
  lib,
  stdenv,
  fetchurl,
  flex,
  bison,
  sendmailPath ? "/run/wrappers/bin/sendmail",
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "petidomo";
  version = "4.3";

  src = fetchurl {
    url = "mirror://sourceforge/petidomo/petidomo-${finalAttrs.version}.tar.gz";
    hash = "sha256-ddNw0fq2MQLJd6YCmIkf9lvq9/Xscl94Ds8xR1hfjXQ=";
  };

  buildInputs = [
    flex
    bison
  ];

  configureFlags = [ "--with-mta=${sendmailPath}" ];

  # test.c:43:11: error: implicit declaration of function 'gets'; did you mean 'fgets'?
  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";

  enableParallelBuilding = true;

  doCheck = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    homepage = "https://petidomo.sourceforge.net/";
    description = "Simple and easy to administer mailing list server";
    license = lib.licenses.gpl3Plus;

    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.peti ];
  };
})
